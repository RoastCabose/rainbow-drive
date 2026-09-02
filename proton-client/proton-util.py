import subprocess
import json
from pathlib import Path
import datetime as dt

folders = {'type': "folder", 'name': "home", 'modified':"sometime", 'created':"sometime", "children":[]}
file = {'type':"file", 'name': "exmaple.txt", 'modified':"sometime", 'created':"sometime", 'filesize': 3000}

PROTON_DIR = "root/"
REMOTE_DIR = "my-files/"

def syncFiles():
    # cache = getCachedFileHistroy()
    # remoteFileTree = getRemoteFileInfos()
    # localFileTree = getLocalFileInfos()
    # newCache = cacheNewHistory(remoteFileTree, localFileTree)
    #
    # saveCache(newCache)
    # 
    # conflicts = getFileConflicts(cache, newCache)
    #
    # operations = []
    #
    # operations.append(getInputforResolution(conflicts))
    #
    # operations.append(getFilesToUpload(cache, newCache))
    # operations.append(getFilesToDownload(cache, newCache))
    #
    # errors = execute(operations)
    # 
    # display(errors)
    # 
    # 
    return

class File:
    def __init__(self, pathStr, dateModified, dateCreated, totalSize):
        self.path = Path(pathStr)
        self.modified = dateModified
        self.created = dateCreated
        self.size = totalSize

    def isDir():
        return False

class Directory:
    def __init__(self, pathStr, dateModified, dateCreated):
        self.path = Path(pathStr)
        self.modified = dt.datetime.fromtimestamp(int(dateModified))
        self.created = dt.datetime.fromtimestamp(int(dateCreated))
        self.children = []

    def __str__(self):
        string = [self.path.name]
        string.append("Created: " + self.created.isoformat() + " | Modified: " + self.modified.isoformat)
        

    def isDir(self):
        return True

def getDirItems_local(path):
    result = subprocess.run(["ls", path], capture_output=True, text=True)
    items = result.stdout.split("\n")
    return map(lambda name: path + name, items[:len(items) - 1])
    
def createFileObject_local(path):
    result = subprocess.run(["stat", "-c", "%F\n%n\n%Y\n%W\n%s", path], capture_output=True, text=True)
    info = result.stdout.split("\n")
    if info[0] == "directory":
        return Directory(info[1], )
    else:
        return File(info)

def getDirectoryContents(dir, listFunc, createFunc):
    items = listFunc(dir.name)
    objects = map(createFunc, items)
    for object in objects:
        if object.isDir():
            object.children = getDirectoryContents(object)
    return objects

def getLocalFileTree():
    test = "test"
    localBase = createFileObject_local(test)
    localBase.children = getDirectoryContents(localBase, getDirItems_local, createFileObject_local)
    return localBase
    
    
def main():
    localTree = getLocalFileTree()
    print(localTree)
    return 0

if __name__ == '__main__':
    main()
