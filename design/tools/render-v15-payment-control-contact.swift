import AppKit
import ImageIO
let root="design/states/D2-payment-control-pilot-v15"
let m=try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:root+"/measurements.json"))) as! [String:Any]
let cases=m["cases"] as! [[String:Any]]
for key in ["AZ-P1","AZ-P3","confirm","pending","paid-success","failed","unknown"] {
 let selected=cases.filter {c in let id=c["id"] as! String;return key.hasPrefix("AZ") ? id.hasPrefix(key=="AZ-P1" ? "P1-I0":"P3-I0") : id.hasPrefix("P1-I2") && (c["fixture"] as! String)==key+"-mixed-guide-term"}
 var images=[CGImage]()
 for c in selected {for p in c["pages"] as! [[String:Any]] {let src=CGImageSourceCreateWithURL(URL(fileURLWithPath:p["path"] as! String) as CFURL,nil)!;let im=CGImageSourceCreateImageAtIndex(src,0,nil)!
 for a in p["items"] as! [[String:Any]] where a["action"] as! Bool {let r=a["rect"] as! [CGFloat];images.append(im.cropping(to:CGRect(x:r[0],y:r[1],width:r[2],height:r[3]))!)} }}
 let width=images.map{$0.width}.max()!, height=images.reduce(0){$0+$1.height+24}
 let ctx=CGContext(data:nil,width:width,height:height,bitsPerComponent:8,bytesPerRow:width*4,space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue)!
 ctx.setFillColor(NSColor.white.cgColor);ctx.fill(CGRect(x:0,y:0,width:width,height:height));var y=height
 for im in images {y-=im.height;ctx.draw(im,in:CGRect(x:0,y:y,width:im.width,height:im.height));y-=24}
 let dest=CGImageDestinationCreateWithURL(URL(fileURLWithPath:root+"/controls-"+key+".png") as CFURL,"public.png" as CFString,1,nil)!;CGImageDestinationAddImage(dest,ctx.makeImage()!,nil);precondition(CGImageDestinationFinalize(dest))
}
