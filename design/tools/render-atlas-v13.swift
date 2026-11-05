// Static D1 inventory design only. No app or game code.
import AppKit
import CoreText
import CryptoKit
func read(_ p:String)->[String:Any]{try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:p))) as! [String:Any]}
let roles=(read("design/states/D1-canonical-render-matrix.json")["typeTrial"] as! [String:Any])["roles"] as! [String:[String:Int]]
let refs=read("design/states/D6-canonical-token-proposal.json")["referenceColors"] as! [String:[String:String]]
func color(_ k:String)->NSColor{let v=UInt32(refs[k]!["value"]!.dropFirst(),radix:16)!;return NSColor(srgbRed:CGFloat((v>>16)&255)/255,green:CGFloat((v>>8)&255)/255,blue:CGFloat(v&255)/255,alpha:1)}
let manifest=read("design/states/D1-font-binary-manifest.json")["fonts"] as! [[String:Any]]
let f=manifest.first{$0["id"] as! String == "NotoSans"}!
let data=try! Data(contentsOf:URL(fileURLWithPath:f["path"] as! String))
precondition(SHA256.hash(data:data).map{String(format:"%02x",$0)}.joined()==f["sha256"] as! String)
let cg=CGFont(CGDataProvider(data:data as CFData)!)!
var scale=1.0, resolved=Set<String>(), missing=0
var fontCache:[String:CTFont]=[:]
func font(_ role:String)->CTFont{let key="\(role)-\(scale)";if let cached=fontCache[key]{return cached};let r=roles[role]!;let d=CTFontDescriptorCreateWithAttributes([kCTFontVariationAttribute:[NSNumber(value:0x77676874):NSNumber(value:r["weight"]!),NSNumber(value:0x77647468):100]] as CFDictionary);let result=CTFontCreateWithGraphicsFont(cg,CGFloat(Double(r["sizeSp"]!*2)*scale),nil,d);fontCache[key]=result;return result}
struct Shaped {let lines:[CTLine];let step:CGFloat;let height:CGFloat;let maxWidth:CGFloat}
func shape(_ text:String,_ role:String,_ width:CGFloat,_ colorName:String="nav")->Shaped{
 if text.isEmpty{return Shaped(lines:[],step:0,height:0,maxWidth:0)}
 let a=NSAttributedString(string:text,attributes:[.font:font(role),.foregroundColor:color(colorName)])
 let ts=CTTypesetterCreateWithAttributedString(a);var i=0,ll:[CTLine]=[],mw:CGFloat=0
 while i<a.length{let n=CTTypesetterSuggestLineBreak(ts,i,Double(width));precondition(n>0);let line=CTTypesetterCreateLine(ts,CFRange(location:i,length:n));ll.append(line);i+=n
 mw=max(mw,CGFloat(CTLineGetTypographicBounds(line,nil,nil,nil)-CTLineGetTrailingWhitespaceWidth(line)))
 for run in CTLineGetGlyphRuns(line) as! [CTRun]{let attr=CTRunGetAttributes(run) as NSDictionary;resolved.insert(CTFontCopyPostScriptName(attr[kCTFontAttributeName] as! CTFont) as String);let count=CTRunGetGlyphCount(run);var glyphs=[CGGlyph](repeating:0,count:count);CTRunGetGlyphs(run,CFRange(location:0,length:0),&glyphs);missing+=glyphs.filter{$0==0}.count}
 }
 let step=CGFloat(Double(roles[role]!["lineHeightSp"]!*2)*scale)
 return Shaped(lines:ll,step:step,height:CGFloat(ll.count)*step,maxWidth:mw)
}
func paint(_ text:String,_ role:String,_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ c:String="nav"){
 let shaped=shape(text,role,width,c);let ctx=NSGraphicsContext.current!.cgContext
 for (i,line) in shaped.lines.enumerated(){ctx.saveGState();ctx.translateBy(x:x,y:y+CGFloat(i)*shaped.step+CTFontGetAscent(font(role)));ctx.scaleBy(x:1,y:-1);ctx.textPosition = .zero;CTLineDraw(line,ctx);ctx.restoreGState()}
}
func box(_ rect:CGRect,_ c:String){color(c).setFill();rect.fill()}
func bitmap(_ w:Int,_ h:Int,_ draw:()->Void)->NSBitmapImageRep{let b=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:w,pixelsHigh:h,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!;NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:b);let ctx=NSGraphicsContext.current!.cgContext;ctx.translateBy(x:0,y:CGFloat(h));ctx.scaleBy(x:1,y:-1);draw();NSGraphicsContext.restoreGraphicsState();return b}
func save(_ b:NSBitmapImageRep,_ p:String){try! b.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:p))}

// Art integration into a static screen renderer; no gameplay implementation.
let tok=read("design/states/D1-pixel-composition-tokens.json"),geo=read("design/states/D1-pixel-composition-tokens.json")["geometry"] as! [String:Int]
let art=tok["art"] as! [String:Any]
let source=NSImage(contentsOfFile:art["source"] as! String)!.cgImage(forProposedRect:nil,context:nil,hints:nil)!
func g(_ k:String)->CGFloat{CGFloat(geo[k]!)}
func crop(_ key:String,_ r:CGRect){let a=art[key] as! [Int];let src=["cloth","wood","grain"].contains(key) ? NSImage(contentsOfFile:art["iconSource"] as! String)!.cgImage(forProposedRect:nil,context:nil,hints:nil)!:source;let im=src.cropping(to:CGRect(x:a[0],y:a[1],width:a[2],height:a[3]))!;let c=NSGraphicsContext.current!.cgContext;c.saveGState();c.interpolationQuality = .none;c.translateBy(x:r.minX,y:r.maxY);c.scaleBy(x:1,y:-1);c.draw(im,in:CGRect(origin:.zero,size:r.size));c.restoreGState()}
func frame(_ r:CGRect){box(r,"paper");let e=g("frameEdge");crop("frameTop",CGRect(x:r.minX,y:r.minY,width:r.width,height:e));crop("frameBottom",CGRect(x:r.minX,y:r.maxY-e,width:r.width,height:e));crop("frameLeft",CGRect(x:r.minX,y:r.minY+e,width:e,height:r.height-2*e));crop("frameRight",CGRect(x:r.maxX-e,y:r.minY+e,width:e,height:r.height-2*e))}
let langs=read("design/states/D1-render-localization.json")["languages"] as! [String:[String:String]]
let fixture=read("design/states/D1-render-fixture.json"),base=read("design/states/D1-render-fixture.json")["base"] as! [String:Any]
let goods=base["goods"] as! [[String:Any]]

let out="design/states/atlas-normalized-v13"
try! FileManager.default.createDirectory(atPath:out,withIntermediateDirectories:true)
let atlas=NSImage(contentsOfFile:"design/assets/barterune-art-v13.png")!.cgImage(forProposedRect:nil,context:nil,hints:nil)!
func artCell(_ index:Int,_ r:CGRect){
 let unit=CGFloat(atlas.width)/4
 let image=atlas.cropping(to:CGRect(x:CGFloat(index%4)*unit,y:CGFloat(index/4)*unit,width:unit,height:unit))!
 let c=NSGraphicsContext.current!.cgContext;c.saveGState();c.interpolationQuality = .none;c.translateBy(x:r.minX,y:r.maxY);c.scaleBy(x:1,y:-1);c.draw(image,in:CGRect(origin:.zero,size:r.size));c.restoreGState()
}
func icon(_ id:String,_ r:CGRect){
 if ["grain","wood","cloth"].contains(id){crop(id,r);return}
 let indices=["spices":0,"iron":1,"salt":2,"wool":3,"herbs":4,"mana_crystal":5,"dragon_resin":6]
 artCell(indices[id]!,r)
}

// Atlas-only static proof: original semantic indices, token-based surfaces.
let names=["Ədviyyat","Dəmir","Duz","Yun","Otlar","Mana kristalı","Əjdaha qatranı","Boş","Bələdçi","Mühafizəçi","Boş","Boş","Yola çıxış","Quldur","Fırtına","Təmir"]
let margin=g("margin"),gap=g("gap"),target=g("target"),pad=g("inset")
let cell=2*target
save(bitmap(Int(4*(cell+gap)+gap),Int(4*(cell+target+2*pad)+gap)){
 box(CGRect(x:0,y:0,width:4*(cell+gap)+gap,height:4*(cell+target+2*pad)+gap),"paper")
 for i in 0..<16 {
  let x=gap+CGFloat(i%4)*(cell+gap),y=gap+CGFloat(i/4)*(cell+target+2*pad)
  artCell(i,CGRect(x:x,y:y,width:cell,height:cell))
  paint("\(i) · \(names[i])","label",x,y+cell+pad,cell)
 }
},"\(out)/atlas-on-paper.png")
for (id,indices) in [("services",[8,9]),("events",[12,13,14,15]),("goods",Array(0...6))] {
 let width=CGFloat(indices.count)*(cell+gap)+gap
 save(bitmap(Int(width),Int(cell+2*target)){
  box(CGRect(x:0,y:0,width:width,height:cell+2*target),"nav")
  for (n,i) in indices.enumerated(){let x=gap+CGFloat(n)*(cell+gap)
   box(CGRect(x:x,y:gap,width:cell,height:cell),"paper")
   artCell(i,CGRect(x:x,y:gap,width:cell,height:cell))
   paint(names[i],"label",x,cell+2*gap,cell,"paper")
  }
 },"\(out)/\(id).png")
}
print("Atlas proofs: 4; missingGlyphs=\(missing)")
