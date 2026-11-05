import AppKit
import ImageIO
let root="design/states/D2-payment-pilot-v15"
let selectedID=CommandLine.arguments[1]
let verification=try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:root+"/measurements.json"))) as! [String:Any]
let cases=verification["cases"] as! [[String:Any]]
let selected=cases.filter{($0["id"] as! String)==selectedID}
let paths=selected.flatMap{($0["pages"] as! [[String:Any]]).map{$0["path"] as! String}}
let cols=2,rows=(paths.count+cols-1)/cols,w=1280,h=rows*360
// Use a bitmap CGContext directly; avoid AppKit's ambient graphics state.
let c=CGContext(data:nil,width:w,height:h,bitsPerComponent:8,bytesPerRow:w*4,space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue)!
c.translateBy(x:0,y:CGFloat(h));c.scaleBy(x:1,y:-1)
for (i,p) in paths.enumerated(){let src=CGImageSourceCreateWithURL(URL(fileURLWithPath:p) as CFURL,nil)!;let im=CGImageSourceCreateImageAtIndex(src,0,nil)!;c.saveGState();c.translateBy(x:CGFloat(i%cols)*640,y:CGFloat(i/cols+1)*360);c.scaleBy(x:1,y:-1);let factor=min(640/CGFloat(im.width),360/CGFloat(im.height));c.draw(im,in:CGRect(x:0,y:0,width:CGFloat(im.width)*factor,height:CGFloat(im.height)*factor));c.restoreGState()}
let destination=CGImageDestinationCreateWithURL(URL(fileURLWithPath:root+"/contact-"+selectedID+".png") as CFURL,"public.png" as CFString,1,nil)!
CGImageDestinationAddImage(destination,c.makeImage()!,nil)
precondition(CGImageDestinationFinalize(destination))
