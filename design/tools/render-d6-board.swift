// Documentation mockup renderer only; no game/runtime code.
import AppKit
let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
func read(_ path: String) -> [String:Any] {
    try! JSONSerialization.jsonObject(with: Data(contentsOf: root.appendingPathComponent(path))) as! [String:Any]
}
let spec=read("design/states/D6-adaptation-spec.json")
let tokens=read("design/states/D1-board-tokens.json")
let layout=tokens["layout"] as! [String:Int], sizes=tokens["type"] as! [String:Int]
let colors=tokens["colors"] as! [String:String]
func color(_ name:String)->NSColor {
 let value=UInt32(colors[name]!.dropFirst(),radix:16)!
 return NSColor(srgbRed:CGFloat((value>>16)&255)/255,green:CGFloat((value>>8)&255)/255,blue:CGFloat(value&255)/255,alpha:1)
}
let states=spec["states"] as! [[String:Any]]
let gap=layout["space"]!, width=layout["width"]!, header=layout["header"]!, ch=layout["cardHeight"]!
let height=header+((states.count+1)/2)*(ch+gap)+gap
let bitmap=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:width,pixelsHigh:height,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:bitmap)
let ctx=NSGraphicsContext.current!.cgContext
ctx.translateBy(x:0,y:CGFloat(height));ctx.scaleBy(x:1,y:-1)
func box(_ x:Int,_ y:Int,_ w:Int,_ h:Int,_ c:String){color(c).setFill();NSRect(x:x,y:y,width:w,height:h).fill()}
func text(_ s:String,_ x:Int,_ y:Int,_ w:Int,_ h:Int,_ size:String,_ c:String="nav",_ bold:Bool=false){
 let p=NSMutableParagraphStyle();p.lineBreakMode = .byWordWrapping
 let attrs:[NSAttributedString.Key:Any]=[.font:bold ? NSFont.boldSystemFont(ofSize:CGFloat(sizes[size]!)):NSFont.systemFont(ofSize:CGFloat(sizes[size]!)),.foregroundColor:color(c),.paragraphStyle:p]
 // NSString draws in unflipped text coordinates, so flip locally.
 ctx.saveGState();ctx.translateBy(x:CGFloat(x),y:CGFloat(y+h));ctx.scaleBy(x:1,y:-1)
 (s as NSString).draw(with:NSRect(x:0,y:0,width:w,height:h),options:[.usesLineFragmentOrigin,.usesFontLeading],attributes:attrs)
 ctx.restoreGState()
}
box(0,0,width,height,"paper")
text("D6 • Uyğunlaşma və vizual sistem",gap,gap,width-2*gap,52,"title","nav",true)
text("İlkin müqavilə • Token təklifi / cihaz / dil / toxunma / hərəkət • Real cihaz yoxlanmayıb",gap,82,width-2*gap,40,"body")
let cw=(width-3*gap)/2
for (index,s) in states.enumerated(){
 let x=gap+(index%2)*(cw+gap), y=header+(index/2)*(ch+gap)
 box(x,y,cw,ch,"nav");box(x+2,y+2,cw-4,ch-4,"paper")
 box(x,y,cw,52,"nav")
 text("\(s["id"]!)  \(s["name"]!)",x+gap,y+8,cw-2*gap,38,"heading","paper",true)
 text(s["hud"] as! String,x+gap,y+68,cw-2*gap,38,"body","nav",true)
 text(s["detail"] as! String,x+gap,y+116,cw-2*gap,66,"body")
 let bw=(cw-3*gap)/2
 for (j,k) in ["buy","sell"].enumerated(){
  let bx=x+gap+j*(bw+gap);box(bx,y+192,bw,64,"nav")
  text(s[k] as! String,bx+8,y+200,bw-16,52,"body","paper",true)
 }
 text(s["rule"] as! String,x+gap,y+272,cw-2*gap,92,"note")
}
NSGraphicsContext.restoreGraphicsState()
try! bitmap.representation(using:.png,properties:[:])!.write(to:root.appendingPathComponent(spec["output"] as! String))
print(spec["output"]!)
