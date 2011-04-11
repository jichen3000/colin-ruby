#!/usr/bin/ruby -w
# S3lib.rb

# Libraries neccessary for making HTTP requests and parsing responses.
require 'rubygems'
require 'rest-open-uri'
require 'rexml/document'

# Libraries neccessary for request signing
require 'openssl'
require 'digest/sha1'
require 'base64'
require 'uri'

module S3 # This is the beginning of a big, all-encompassing module.

module Authorized
  # Enter your public key (Amazon calls it an "Access Key ID") and
  # your private key (Amazon calls it a "Secret Access Key"). This is
  # so you can sign your S3 requests and Amazon will know who to
  # charge.
  @@public_key = '1ABGMC4THP9F383DZNR2'
  @@private_key = 'Fib94Ml6ZQ4JfpN+0C50tfSyX1XssPLgDlco4yEo'

  if @@public_key.empty? or @@private_key.empty?  
    raise "You need to set your S3 keys."
  end

  # You shouldn't need to change this unless you're using an S3 clone like
  # Park Place.
  HOST = 'https://s3.amazonaws.com/'
end

##

# The bucket list.
class BucketList
  include Authorized

  # Fetch all the buckets this user has defined.
  def get
    buckets = []

    # GET the bucket list URI and read an XML document from it.
    doc = REXML::Document.new(open(HOST).read)

    # For every bucket...
    REXML::XPath.each(doc, "//Bucket/Name") do |e|
      # ...create a new Bucket object and add it to the list.
      buckets << Bucket.new(e.text) if e.text
    end
    return buckets
  end
end

##

# A bucket that you've stored (or will store) on the S3 application.
class Bucket
  include Authorized
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  # The URI to a bucket is the service root plus the bucket name.
  def uri
    HOST + URI.escape(name)
  end

  # Stores this bucket on S3. Analagous to ActiveRecord::Base#save,
  # which stores an object in the database. See below in the
  # book text for a discussion of acl_policy.
  def put(acl_policy=nil)
    # Set the HTTP method as an argument to open(). Also set the S3
    # access policy for this bucket, if one was provided.
    args = {:method => :put}
    args["x-amz-acl"] = acl_policy if acl_policy

    # Send a PUT request to this bucket's URI.
    open(uri, args)
    return self
  end

  # Deletes this bucket. This will fail with HTTP status code 409
  # ("Conflict") unless the bucket is empty.
  def delete
    # Send a DELETE request to this bucket's URI.
    open(uri, :method => :delete)
  end

##

  # Get the objects in this bucket: all of them, or some subset.
  #
  # If S3 decides not to return the whole bucket/subset, the second
  # return value will be set to true. To get the rest of the objects,
  # you'll need to manipulate the subset options (not covered in the
  # book text).
  #
  # The subset options are :Prefix, :Marker, :Delimiter, :MaxKeys.
  # For details, see the S3 docs on "Listing Keys".
  def get(options={})
    # Get the base URI to this bucket, and append any subset options
    # onto the query string.
    uri = uri()
    suffix = '?'

    # For every option the user provided...
    options.each do |param, value|      
      # ...if it's one of the S3 subset options...
      if [:Prefix, :Marker, :Delimiter, :MaxKeys].member? :param
        # ...add it to the URI.
        uri << suffix << param.to_s << '=' << URI.escape(value)
        suffix = '&'
      end
    end

    # Now we've built up our URI. Make a GET request to that URI and
    # read an XML document that lists objects in the bucket.
    doc = REXML::Document.new(open(uri).read)
    there_are_more = REXML::XPath.first(doc, "//IsTruncated").text == "true"

    # Build a list of S3::Object objects.
    objects = []
    # For every object in the bucket...
    REXML::XPath.each(doc, "//Contents/Key") do |e|
      # ...build an S3::Object object and append it to the list.
      objects << Object.new(self, e.text) if e.text
    end
    return objects, there_are_more
  end
end

##

# An S3 object, associated with a bucket, containing a value and metadata.
class Object
  include Authorized

  # The client can see which Bucket this Object is in.
  attr_reader :bucket
  
  # The client can read and write the name of this Object.
  attr_accessor :name

  # The client can write this Object's metadata and value.
  # I'll define the corresponding "read" methods later.
  attr_writer :metadata, :value

  def initialize(bucket, name, value=nil, metadata=nil)
    @bucket, @name, @value, @metadata = bucket, name, value, metadata
  end

  # The URI to an Object is the URI to its Bucket, and then its name.
  def uri
    @bucket.uri + '/' + URI.escape(name)
  end

##

  # Retrieves the metadata hash for this Object, possibly fetching
  # it from S3.
  def metadata
    # If there's no metadata yet...
    unless @metadata
      # Make a HEAD request to this Object's URI, and read the metadata
      # from the HTTP headers in the response.
      begin
        store_metadata(open(uri, :method => :head).meta) 
      rescue OpenURI::HTTPError => e
        if e.io.status == ["404", "Not Found"]
          # If the Object doesn't exist, there's no metadata and this is not
          # an error. 
          @metadata = {}
        else
          # Otherwise, this is an error.
          raise e
        end
      end
    end
    return @metadata
  end

##

  # Retrieves the value of this Object, possibly fetching it
  # (along with the metadata) from S3.
  def value
    # If there's no value yet...
    unless @value
      # Make a GET request to this Object's URI.
      response = open(uri)
      # Read the metadata from the HTTP headers in the response.
      store_metadata(response.meta) unless @metadata
      # Read the value from the entity-body
      @value = response.read
    end
    return @value
  end

##

  # Store this Object on S3.
  def put(acl_policy=nil)

    # Start from a copy of the original metadata, or an empty hash if
    # there is no metadata yet.
    args = @metadata ? @metadata.clone : {}

    # Set the HTTP method, the entity-body, and some additional HTTP
    # headers.
    args[:method] = :put
    args["x-amz-acl"] = acl_policy if acl_policy
    if @value
      args["Content-Length"] = @value.size.to_s
      args[:body] = @value
    end

    # Make a PUT request to this Object's URI.
    open(uri, args)
    return self
  end

##

  # Deletes this Object.
  def delete
    # Make a DELETE request to this Object's URI.
    open(uri, :method => :delete)
  end

##

  private

  # Given a hash of headers from a HTTP response, picks out the
  # headers that are relevant to an S3 Object, and stores them in the
  # instance variable @metadata.
  def store_metadata(new_metadata)    
    @metadata = {}
    new_metadata.each do |h,v| 
      if RELEVANT_HEADERS.member?(h) || h.index('x-amz-meta') == 0
        @metadata[h] = v  
      end
    end
  end
  RELEVANT_HEADERS = ['content-type', 'content-disposition', 'content-range',
                      'x-amz-missing-meta']
end

##

module Authorized
  # These are the standard HTTP headers that S3 considers interesting
  # for purposes of request signing.
  INTERESTING_HEADERS = ['content-type', 'content-md5', 'date']

  # This is the prefix for custom metadata headers. All such headers
  # are considered interesting for purposes of request signing.
  AMAZON_HEADER_PREFIX = 'x-amz-'

  # An S3-specific wrapper for rest-open-uri's implementation of
  # open(). This implementation sets some HTTP headers before making
  # the request. Most important of these is the Authorization header,
  # which contains the information Amazon will use to decide who to
  # charge for this request.
  def open(uri, headers_and_options={}, *args, &block)
    headers_and_options = headers_and_options.dup
    headers_and_options['Date'] ||= Time.now.httpdate
    headers_and_options['Content-Type'] ||= ''   
    signed = signature(uri, headers_and_options[:method] || :get,
                       headers_and_options)
    headers_and_options['Authorization'] = "AWS #{@@public_key}:#{signed}"
    p headers_and_options
    Kernel::open(uri, headers_and_options, *args, &block)
  end

##

  # Builds the cryptographic signature for an HTTP request. This is
  # the signature (signed with your private key) of a "canonical
  # string" containing all interesting information about the request.
  def signature(uri, method=:get, headers={}, expires=nil)
    # Accept the URI either as a string, or as a Ruby URI object.
    if uri.respond_to? :path
      path = uri.path
    else
      uri = URI.parse(uri)
      path = uri.path + (uri.query ? "?" + query : "")
    end

    # Build the canonical string, then sign it.
    signed_string = sign(canonical_string(method, path, headers, expires))
  end

##

  # Turns the elements of an HTTP request into a string that can be
  # signed to prove a request comes from your web service account.
  def canonical_string(method, path, headers, expires=nil)

    # Start out with default values for all the interesting headers.
    sign_headers = {}
    INTERESTING_HEADERS.each { |header| sign_headers[header] = '' }

    # Copy in any actual values, including values for custom S3
    # headers.
    headers.each do |header, value|
      if header.respond_to? :to_str
        header = header.downcase
        # If it's a custom header, or one Amazon thinks is interesting...
        if INTERESTING_HEADERS.member?(header) ||
            header.index(AMAZON_HEADER_PREFIX) == 0
          # Add it to the header has.
          sign_headers[header] = value.to_s.strip
        end
      end
    end
 
    # This library eliminates the need for the x-amz-date header that
    # Amazon defines, but someone might set it anyway. If they do,
    # we'll do without HTTP's standard Date header.
    sign_headers['date'] = '' if sign_headers.has_key? 'x-amz-date'

    # If an expiration time was provided, it overrides any Date
    # header. This signature will be valid until the expiration time,
    # not only during the single second designated by the Date header.
    sign_headers['date'] = expires.to_s if expires

    # Now we start building the canonical string for this request. We
    # start with the HTTP method.
    canonical = method.to_s.upcase + "\n"

    # Sort the headers by name, and append them (or just their values)
    # to the string to be signed.
    sign_headers.sort_by { |h| h[0] }.each do |header, value|
      canonical << header << ":" if header.index(AMAZON_HEADER_PREFIX) == 0
      canonical << value << "\n"
    end

    # The final part of the string to be signed is the URI path. We
    # strip off the query string, and (if neccessary) tack one of the
    # special S3 query parameters back on: 'acl', 'torrent', or
    # 'logging'.
    canonical << path.gsub(/\?.*$/, '')

    for param in ['acl', 'torrent', 'logging']
      if path =~ Regexp.new("[&?]#{param}($|&|=)")
        canonical << "?" << param
        break
      end
    end
    return canonical
  end

##

  # Signs a string with the client's secret access key, and encodes the
  # resulting binary string into plain ASCII with base64.
  def sign(str)
    digest_generator = OpenSSL::Digest::Digest.new('sha1')
    digest = OpenSSL::HMAC.digest(digest_generator, @@private_key, str)
    return Base64.encode64(digest).strip
  end

##

  # Given information about an HTTP request, returns a URI you can
  # give to anyone else, to let them them make that particular HTTP
  # request as you. The URI will be valid for 15 minutes, or until the
  # Time passed in as the :expires option.
  def signed_uri(headers_and_options={}) 
    expires = headers_and_options[:expires] || (Time.now.to_i + (15 * 60))
    expires = expires.to_i if expires.respond_to? :to_i
    headers_and_options.delete(:expires) 
    signature = URI.escape(signature(uri, headers_and_options[:method], 
                                     headers_and_options, nil))
    q = (uri.index("?")) ? "&" : "?"
    "#{uri}#{q}Signature=#{signature}&Expires=#{expires}&AWSAccessKeyId=#{@@public_key}"
  end
end

end # Remember the all-encompassing S3 module? This is the end.

bl = S3::BucketList.new
bl.get
p bl
p "ok"
