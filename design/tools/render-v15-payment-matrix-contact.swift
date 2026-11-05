import AppKit
import ImageIO
let root="design/states/D2-payment-matrix-v15"
let lang=CommandLine.arguments[1]
let verification=try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:root+"/verification-P1.json"))) as! [String:Any]
let cases=verification["cases"] as! [[String:Any]]
let selected=cases.filter{($0["profile"] as! String)=="P1" && ($0["inset"] as! String)=="I2" && ($0["language"] as! String)==lang && ($0["fontScale"] as! Double)==2 && ($0["fixture"] as! String).hasSuffix("mixed-guide-term")}
let paths=selected.flatMap{$0["pages"] as! [String]}
let cols=3,rows=(paths.count+cols-1)/cols,w=1920,h=rows*360
// Use a bitmap CGContext directly; avoid AppKit's ambient graphics state.
let c=CGContext(data:nil,width:w,height:h,bitsPerComponent:8,bytesPerRow:w*4,space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue)!
c.translateBy(x:0,y:CGFloat(h));c.scaleBy(x:1,y:-1)
for (i,p) in paths.enumerated(){let src=CGImageSourceCreateWithURL(URL(fileURLWithPath:p) as CFURL,nil)!;let im=CGImageSourceCreateImageAtIndex(src,0,nil)!;c.saveGState();c.translateBy(x:CGFloat(i%cols)*640,y:CGFloat(i/cols+1)*360);c.scaleBy(x:1,y:-1);c.draw(im,in:CGRect(x:0,y:0,width:640,height:360));c.restoreGState()}
let destination=CGImageDestinationCreateWithURL(URL(fileURLWithPath:root+"/contact-"+lang+".png") as CFURL,"public.png" as CFString,1,nil)!
CGImageDestinationAddImage(destination,c.makeImage()!,nil)
precondition(CGImageDestinationFinalize(destination))
