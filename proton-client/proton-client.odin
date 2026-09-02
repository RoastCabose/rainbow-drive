package main

import "core:mem"
import fp "core:path/filepath"
import "core:os"

LOCAL_DIR :: "root"
REMOTE_DIR :: "my-files"

FileType :: union {
	^File,
	^Directory
}

FileObject :: struct {
	name: string,
	created: int,
	modified: int,

	type: FileType
}

File :: struct {
	using fileObject: FileObject,
	size: int
}

Directory :: struct {
	using fileObject: FileObject,
	children: [dynamic]FileObject
}

createFileObject :: proc($T: typeid/FileType, name: string, created, modified: int, size:= 0) -> T {
	obj := T{name, created, modified}
	if T == File {
		obj.size = size
	}
	obj.type = ^obj
	return obj
}

newFileObject_local :: proc(path: string) -> FileObject {
	result := something()
	info := something()
	if info[0] == "directory" {
		return createFileObject(Directory, info[1], info[2], info[3])
	} else {
		return createFileObject(File, info[1], info[2], info[3], info[4])
	}
}

createLocalFileTree :: proc(path: string) -> Directory {
	path, err := fp.abs(path)
	if err != nil {
		localBase = newFileObject_local(path)
		return localBase
	}
}


main :: proc() {
	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}
	
	//localFileTree := createLocalFileTree(LOCAL_DIR)
	//remoteFileTree := getRemoteFileTree()
}
