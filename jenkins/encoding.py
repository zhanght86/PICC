#!/usr/bin/env python
#coding:utf-8

import os ,sys

def convert(filename, in_ecode="GBK",out_ecode="UTF-8"):
        try:
                print "convert" + filename
                content = open(filename).read()
                new_content = content.decode(in_ecode).encode(out_ecode)
                open(filename,'w').write(new_content)
                print "done!"
        except:
                print "error!"

def explore(dir):
        for root,dirs,files in os.walk(dir):
                for file in files:
                        if file[-5:] == ".java":
                                path = os.path.join(root,file)
                                convert(path)

def main():
        for path in sys.argv[1:]:
                if os.path.isfile(path):
                        convert(path)
                elif os.path.isdir(path):
                        explore(path)

if __name__ == "__main__":
        main()