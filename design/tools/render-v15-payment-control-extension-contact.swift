import AppKit
import ImageIO
let root="design/states/D2-payment-control-extension-v15"
let m=try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:root+"/measurements.json"))) as! [String:Any]
let cases=m["cases"] as! [[String:Any]]
let states=["confirm","pending","paid-success","failed","unknown"]
let interactions=["normal","primary-pressed","primary-focused","primary-focused-pressed","back-pressed","back-focused","back-focused-pressed"]
// Contact-only grid geometry; no product tokens introduced.
for lang in ["AZ","TR","RU","EN"] {for pid in ["P3","P1"] {
 let cellW=280,cellH=240,width=cellW*7,height=cellH*5
 let b=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:width,pixelsHigh:height,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
 NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:b)
 NSColor.white.setFill();NSRect(x:0,y:0,width:width,height:height).fill()
 for (row,state) in states.enumerated(){for (col,interaction) in interactions.enumerated(){
 let x=col*cellW,y=height-(row+1)*cellH
 let label="\(lang) \(pid) \(state)\n\(interaction)"
 (label as NSString).draw(in:NSRect(x:x+4,y:y+cellH-36,width:cellW-8,height:36),withAttributes:[.font:NSFont.systemFont(ofSize:12),.foregroundColor:NSColor.black])
 guard let c=cases.first(where:{($0["id"] as! String).hasPrefix(pid+"-I"+(pid=="P3" ? "0":"2")+"-"+lang+"-") && ($0["fixture"] as! String).hasPrefix(state+"-") && $0["interaction"] as! String==interaction}) else {continue}
 var yy=y+cellH-42
 for page in c["pages"] as! [[String:Any]] {let source=CGImageSourceCreateWithURL(URL(fileURLWithPath:page["path"] as! String) as CFURL,nil)!;let im=CGImageSourceCreateImageAtIndex(source,0,nil)!
 for a in page["items"] as! [[String:Any]] where a["action"] as! Bool {
 let r=a["rect"] as! [CGFloat];let cropped=im.cropping(to:CGRect(x:r[0],y:r[1],width:r[2],height:r[3]))!
 let factor=min(CGFloat(cellW-8)/CGFloat(cropped.width),CGFloat(84)/CGFloat(cropped.height));let ww=CGFloat(cropped.width)*factor,hh=CGFloat(cropped.height)*factor
 yy-=Int(hh);NSGraphicsContext.current!.cgContext.draw(cropped,in:CGRect(x:CGFloat(x+4),y:CGFloat(yy),width:ww,height:hh));yy-=8
 }
 }
 }}
 NSGraphicsContext.restoreGraphicsState()
 try! b.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:root+"/controls-\(lang)-\(pid).png"))
}}
