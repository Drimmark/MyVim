#!/bin/bash

#Check root
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root"
	exit 1
fi

if [ "$1" != "t" -a "$1" != "s" ]; then
	echo "First parameter must be Split(s) or Tabs(t) mode"
	exit 1
fi

if [ -z "$2" ]; then
	echo "Second argument must be your account username"
	exit 1
fi

while [ ! -d "/home/$2" ]
do
	echo "Write your user mode username: "
	read USERNAME
done
HOMEPATH="/home/$2"
cd $HOMEPATH

echo "
\t##########################
\t#  VIM ENV INSTALLATION  #
\t##########################
"

#Install vim
echo "---Installing vim-nox..."
apt-get install -y vim-nox > /dev/null

#Create folders
mkdir -p "$HOMEPATH/.vim/autoload" "$HOMEPATH/.vim/bundle" "$HOMEPATH/.vim/colors"

#Download panthogen
echo "---Installing pathogen..."
git clone -q https://github.com/tpope/vim-pathogen.git
mv $HOMEPATH/vim-pathogen/autoload/pathogen.vim $HOMEPATH/.vim/autoload/pathogen.vim
rm -rf $HOMEPATH/vim-pathogen

#Download syntastic
echo "---Installing syntastic..."
git clone -q https://github.com/scrooloose/syntastic.git $HOMEPATH/.vim/bundle/syntastic

#Download vim-polyglot
echo "---Installing vim-polyglot..."
git clone -q https://github.com/sheerun/vim-polyglot.git $HOMEPATH/.vim/bundle/vim-polyglot

#Download vim-go
echo "---Installing vim-go..."
git clone -q https://github.com/fatih/vim-go.git $HOMEPATH/.vim/bundle/vim-go

#Download nerdtree
echo "---Installing nerdtree..."
git clone -q https://github.com/scrooloose/nerdtree.git $HOMEPATH/.vim/bundle/nerdtree

#Download neocomplete
echo "---Installing neocomplete..."
git clone -q https://github.com/Shougo/neocomplete.vim.git $HOMEPATH/.vim/bundle/neocomplete.vim

#Download monokai color schema
echo "---Installing monokai color schema..."
git clone -q https://github.com/sickill/vim-monokai.git
mv $HOMEPATH/vim-monokai/colors/monokai.vim $HOMEPATH/.vim/colors/monokai.vim
rm -rf $HOMEPATH/vim-monokai


TABS="
execute pathogen#infect()\n
syntax enable\n
filetype plugin on\n
\" Syntastic\n
set statusline+=%#warningmsg#\n
set statusline+=%{SyntasticStatuslineFlag()}\n
set statusline+=%*\n
\n
let g:syntastic_always_populate_loc_list = 1\n
let g:syntastic_auto_loc_list = 1\n
let g:syntastic_check_on_open = 1\n
let g:syntastic_check_on_wq = 0\n
\n
\" Syntastic Golang\n
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']\n
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go']  }\n
\n
\" General\n
set number\n
set mouse=a\n
set completeopt-=preview\n
\n
let g:go_disable_autoinstall = 0\n
\n
colorscheme monokai\n
\n
\" Highlight\n
let g:go_highlight_functions = 1\n
let g:go_highlight_methods = 1\n
let g:go_highlight_structs = 1\n
let g:go_highlight_operators = 1\n
let g:go_highlight_build_constraints = 1\n
\n
\" Autocomplete\n
let g:neocomplete#enable_at_startup = 1\n
let g:neocomplete#enable_auto_select = 0\n
\n
\" FileTree\n
map <silent> <C-n> :NERDTreeToggle<CR>\n
\n
\" Tabs with NerdTree\n
map <silent> <C-t> :tabnew<CR>\n
map <silent> <Tab> :tabNext<CR>\n
\n
\" Auto indent\n
map <silent> <F7> mzgg=G\`z<CR>\n
\" Undo\n
map <silent> <C-z> :u <CR>
"

SPLIT="
execute pathogen#infect()\n
syntax enable\n
filetype plugin on\n
\" Syntastic\n
set statusline+=%#warningmsg#\n
set statusline+=%{SyntasticStatuslineFlag()}\n
set statusline+=%*\n
\n
let g:syntastic_always_populate_loc_list = 1\n
let g:syntastic_auto_loc_list = 1\n
let g:syntastic_check_on_open = 1\n
let g:syntastic_check_on_wq = 0\n
\n
\" Syntastic Golang\n
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']\n
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go']  }\n
\n
\" General
set number\n
set mouse=a\n
set completeopt-=preview\n
\n
let g:go_disable_autoinstall = 0\n
\n
colorscheme monokai\n
\n
\" Highlight\n
let g:go_highlight_functions = 1\n
let g:go_highlight_methods = 1\n
let g:go_highlight_structs = 1\n
let g:go_highlight_operators = 1\n
let g:go_highlight_build_constraints = 1\n
\n
\" Autocomplete\n
let g:neocomplete#enable_at_startup = 1\n
\n
\" FileTree\n
map <silent> <C-n> :NERDTreeToggle<CR>\n
\n
\" Split with NerdTree\n
map <C-t> :vsplit<CR>\n
map <C-h> :wincmd h<CR>\n
map <C-l> :wincmd l<CR>\n
\n
\" Auto indent\n
map <silent> <F7> mzgg=G\`z<CR>\n
\" Undo\n
map <silent> <C-z> :u <CR>
"

if [ "$1" = "t" ]; then
	echo $TABS > $HOMEPATH/.vimrc
else
	echo $SPLIT > $HOMEPATH/.vimrc
fi

echo "---Setting permissions to vim configuration folder..."
chown -R $2:$2 $HOMEPATH/.vim
chown -R $2:$2 $HOMEPATH/.vimrc

#echo "
#\t##########################
#\t          DONE!
#\tTo complete installation:
#\t 1) Set GOPATH var on your
#\t    environment and GOBIN 
#\t    var as \$GOPATH/bin
#\t 2) Open vim and exec 
#\t    :GoInstallBinaries
#\t 3) Code!
#\t##########################
#"

echo "
\t##########################
\t#         DONE!          #
\t##########################
"
exit 1
