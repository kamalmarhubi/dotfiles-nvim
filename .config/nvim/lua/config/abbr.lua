-- Super handy command mode abbreviation for the directory of the current file.
-- From
--   http://vim.wikia.com/wiki/Easy_edit_of_files_in_the_same_directory#Using_a_command_line_abbreviation
vim.cmd("cabbr <expr> %% expand('%:p:h')")
