#!/bin/bash

list_subdirs() {
    find . -maxdepth 1 -type d ! -name '.'
}

# set the following according to your installation
export IPGRID_HOME=/tmp/ipgrid
export IPGRID_USERNAME=ipgrid_admin
export IPGRID_PASSWORD=ipgrid_pwd

TOP=`pwd`

digicompdirs=(
  'add_sub_8bit'
  'alu_8bit'
  'counter'
  'decoder'
  'encoder'
  'multiplex'
  'multiplier'
  'mux'
  'ram'
  'segment_decoder'
  'shift_reg'
)

DIGICOMPDIR=`pwd`

for entry in ${digicompdirs[@]} ; do
    cd ${DIGICOMPDIR}
    cd $entry

    parnum=$[RANDOM%2+1]
    sentnum=$[RANDOM%4+1]
    descr=`curl http://metaphorpsum.com/paragraphs/${parnum}/${sentnum}`

    ipg prod init --name $entry --type soft_ip --package-sources --description "${entry} - from automated load script"

    subdirs=$(list_subdirs)
    for dir in ${subdirs[@]} ; do
        rel=$(basename "$dir")
        echo "-----------------${rel}-----------------------"

        cd $dir
        rm -rf .ipg

        ipg prod update $entry
        ipg prod add .
        ipg prod commit --release $rel --description-file readme.md

	cd ..
    done
done


