import AppKit
let out="design/states/D1-D6-design-v15"
let data=try! Data(contentsOf:URL(fileURLWithPath:"\(out)/service-integration-diff.json"))
let diff=try! JSONSerialization.jsonObject(with:data) as! [String:Any]
let names=diff["serviceCaptures"] as! [String]
for page in 0..<((names.count+11)/12) {
 let files=Array(names.dropFirst(page*12).prefix(12)),w=1920,h=1440
 let b=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:w,pixelsHigh:h,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
 NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:b)
 let c=NSGraphicsContext.current!.cgContext;c.translateBy(x:0,y:CGFloat(h));c.scaleBy(x:1,y:-1);c.interpolationQuality = .none
 for (i,name) in files.enumerated(){let im=NSImage(contentsOfFile:"\(out)/\(name)")!.cgImage(forProposedRect:nil,context:nil,hints:nil)!
 let r=CGRect(x:(i%3)*640,y:(i/3)*360,width:640,height:360)
 c.saveGState();c.translateBy(x:r.minX,y:r.maxY);c.scaleBy(x:1,y:-1);c.draw(im,in:CGRect(origin:.zero,size:r.size));c.restoreGState()
 }
 NSGraphicsContext.restoreGraphicsState()
 try! b.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:"\(out)/contact-services-\(page+1).png"))
}
