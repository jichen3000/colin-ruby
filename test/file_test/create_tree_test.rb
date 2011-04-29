require 'create_tree'
create_tree './' =>
  [ 'file1',
    'file2',
         { 'subdir1/' => [ 'file1' ] },
         { 'subdir2/' => [ 'file1',
                      'file2',
                       { 'subsubdir/' => [ 'file1' ] }
                     ]
    }
   ]
p Dir['**/**']
