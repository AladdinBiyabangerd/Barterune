// Deterministic raster export after imagegen cleanup; no game code.
import AppKit
let source=NSImage(contentsOfFile:"design/assets/barterune-art-v13-source.png")!.cgImage(forProposedRect:nil,context:nil,hints:nil)!
let grid=4,logicalCell=128,exportScale=2
let side=grid*logicalCell
func raster(_ size:Int,_ draw:(CGContext)->Void)->NSBitmapImageRep {
 let b=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:size,pixelsHigh:size,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
 NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:b)
 let c=NSGraphicsContext.current!.cgContext;c.interpolationQuality = .none;draw(c);NSGraphicsContext.restoreGraphicsState();return b
}
let logical=raster(side){c in c.draw(source,in:CGRect(x:0,y:0,width:side,height:side))}
// Exact binary alpha and reserved empty slots are export invariants.
for y in 0..<side {for x in 0..<side {
 let index=(y/logicalCell)*grid+x/logicalCell
 let c=logical.colorAt(x:x,y:y)!.usingColorSpace(.deviceRGB)!
 let empty=[7,10,11].contains(index)
 let a:CGFloat = empty || c.alphaComponent < 0.5 ? 0 : 1
 logical.setColor(NSColor(deviceRed:c.redComponent,green:c.greenComponent,blue:c.blueComponent,alpha:a),atX:x,y:y)
}}
let output=raster(side*exportScale){c in c.draw(logical.cgImage!,in:CGRect(x:0,y:0,width:side*exportScale,height:side*exportScale))}
try! output.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:"design/assets/barterune-art-v13.png"))
var cells=[[String:Any]]()
for i in 0..<16 {
 var transparent=0,opaque=0
 for y in (i/4*logicalCell)..<(i/4+1)*logicalCell {for x in (i%4*logicalCell)..<(i%4+1)*logicalCell {
  let a=logical.colorAt(x:x,y:y)!.alphaComponent
  if a==0 {transparent+=1};if a==1 {opaque+=1}
 }}
 cells.append(["index":i,"transparentPixels":transparent,"opaquePixels":opaque,"totalPixels":logicalCell*logicalCell])
}
let data:[String:Any]=["grid":grid,"logicalCell":logicalCell,"exportScale":exportScale,"sourceSize":[source.width,source.height],"outputSize":[side*exportScale,side*exportScale],"cells":cells,"method":"Nearest-neighbor 512 logical atlas → 1024 export. Uniform 2x2 pixel blocks; art detail remains an authored visual judgment."]
try! JSONSerialization.data(withJSONObject:data,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"design/states/atlas-normalized-v13/verification.json"))
print("Normalized atlas exported; 16 cells measured")
