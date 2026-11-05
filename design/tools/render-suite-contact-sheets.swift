import AppKit
let root="design/states/D1-D6-design-v8"
let data=try! Data(contentsOf:URL(fileURLWithPath:root+"/verification.json"))
let v=try! JSONSerialization.jsonObject(with:data) as! [String:Any]
let captures=v["captures"] as! [[String:Any]]
for group in ["D1","D2","D3","D4","D5","D6"] {
 let list=captures.filter{($0["screen"] as! String).hasPrefix(group+"/")}
 for start in stride(from:0,to:list.count,by:12){
 let batch=Array(list[start..<min(start+12,list.count)])
 let b=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:2560,pixelsHigh:2160,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
 NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:b)
 NSColor.black.setFill();NSRect(x:0,y:0,width:2560,height:2160).fill()
 for (i,c) in batch.enumerated(){let im=NSImage(contentsOfFile:c["path"] as! String)!;im.draw(in:NSRect(x:(i%3)*854,y:2160-(i/3+1)*540,width:854,height:480),from:.zero,operation:.sourceOver,fraction:1)
 let label=(c["screen"] as! String)+" · "+URL(fileURLWithPath:c["path"] as! String).lastPathComponent
 (label as NSString).draw(in:NSRect(x:(i%3)*854+12,y:2160-(i/3+1)*540+484,width:830,height:48),withAttributes:[.font:NSFont.systemFont(ofSize:24),.foregroundColor:NSColor.white])
 }
 NSGraphicsContext.restoreGraphicsState()
 try! b.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:root+"/contact-\(group)-\(start/12+1).png"))
 }
}
