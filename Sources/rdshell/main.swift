import Foundation

let promptPlaceHoder = "[00:00:00] $ "

func list() -> [String] {
  let fm = FileManager.default
  let content :[String]
  do {
    try content = fm.contentsOfDirectory(atPath: ".")
  } catch {
    content = [String]()
  }
  return content
}

func processCommand(_ fd: CFFileDescriptorNativeDescriptor = STDIN_FILENO) -> Int8 {
    let fileH = FileHandle(fileDescriptor: fd)
    let command = String(data: fileH.availableData,
                         encoding: .utf8)?.trimmingCharacters(
                            in: .whitespacesAndNewlines) ?? ""
    switch command {
    case "exit":
      return -1
    case "ls":
        print(list(), terminator:"\n\(promptPlaceHoder)")
        fflush(__stdoutp)
        return 0
    case "":
        return 1
    default:
        print("Your command: \(command)", terminator:"\n\(promptPlaceHoder)")
        fflush(__stdoutp)
      return 0
    }
    
}

// This is the implementation of the shell using an never-ending loop
/*
print("Welcome to rdShell\n% ", terminator: "")
outerLoop: while true {
    let result = processCommand()
    switch result {
    case -1:
        break outerLoop
    case 1:
        print("Error reading command")
        break outerLoop
    default:
        break
    }
}
print("Bye bye now.")
 */

 
func fileDescriptorCallBack(_ fd: CFFileDescriptor?, _ flags: CFOptionFlags, _ info: UnsafeMutableRawPointer?) {
    let nfd = CFFileDescriptorGetNativeDescriptor(fd)
    let result = processCommand(nfd)
    switch result {
    case -1:
        print("Bye bye now.")
    default:
        registerStdinFileDescriptor()
        // customMode is defined outside as:
        //let customMode = "com.rderik.myevents"
        RunLoop.main.run(mode: RunLoop.Mode(customMode),
                         before: Date.distantFuture)
    }
}

func registerStdinFileDescriptor() {
    let fd = CFFileDescriptorCreate(kCFAllocatorDefault, STDIN_FILENO, false, fileDescriptorCallBack, nil)
    CFFileDescriptorEnableCallBacks(fd, kCFFileDescriptorReadCallBack);
    let source = CFFileDescriptorCreateRunLoopSource(kCFAllocatorDefault, fd, 0)
    
    // customMode is defined outside as:
    //let customMode = "com.rderik.myevents"
    let cfCustomMode: CFRunLoopMode = CFRunLoopMode(customMode as CFString)
    CFRunLoopAddSource(RunLoop.main.getCFRunLoop(), source, cfCustomMode);
}




let customMode = "com.rderik.myevents"
print("Welcome to rdShell\n\(promptPlaceHoder)", terminator: "")
fflush(__stdoutp)
registerStdinFileDescriptor()
let pt = PromptTimer()
pt.start()
RunLoop.main.run(mode: RunLoop.Mode(customMode),
                 before: Date.distantFuture)



