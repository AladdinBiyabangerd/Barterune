import AppKit
import ImageIO
let root="design/states/D1-device-matrix-v15"
let states=["good","buyPreview","sellPreview","quantity","invalid-seven-digits","save-failed","purchase-success","equipment-final"]
for device in ["P2","P3"] {for lang in ["AZ","EN","RU","TR"] {
 autoreleasepool {
 let w=800,h=1600
 let bitmap=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:w,pixelsHigh:h,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
 NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:bitmap)
 let c=NSGraphicsContext.current!.cgContext;c.translateBy(x:0,y:CGFloat(h));c.scaleBy(x:1,y:-1)
 NSColor.white.setFill();CGRect(x:0,y:0,width:w,height:h).fill()
 for (i,state) in states.enumerated(){for (j,scale) in ["1.0","2.0"].enumerated(){
 let name="\(device)-\(lang)-\(scale)x-\(state)"
 let path="\(root)/\(name)/scroll-0.png"
 let src=CGImageSourceCreateWithURL(URL(fileURLWithPath:path) as CFURL,nil)!
 let im=CGImageSourceCreateImageAtIndex(src,0,nil)!
 let x=CGFloat(j*400),y=CGFloat(i*200)
 c.saveGState();c.translateBy(x:x+8,y:y+18);c.scaleBy(x:1,y:-1)
 (name as NSString).draw(at:.zero,withAttributes:[.font:NSFont.systemFont(ofSize:14),.foregroundColor:NSColor.black]);c.restoreGState()
 let height=min(176,CGFloat(im.height)*380/CGFloat(im.width)),width=height*CGFloat(im.width)/CGFloat(im.height)
 c.saveGState();c.translateBy(x:x+8,y:y+24+height);c.scaleBy(x:1,y:-1);c.draw(im,in:CGRect(x:0,y:0,width:width,height:height));c.restoreGState()
 }}
 NSGraphicsContext.restoreGraphicsState()
 try! bitmap.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:"\(root)/contact-\(device)-\(lang).png"))
 }
}}
