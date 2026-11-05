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

let out="design/states/D2-services-v11"
try! FileManager.default.createDirectory(atPath:out,withIntermediateDirectories:true)
let atlas=NSImage(contentsOfFile:"design/assets/barterune-art-v9.png")!.cgImage(forProposedRect:nil,context:nil,hints:nil)!
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
struct Item {var title:String;var body:String;var icon:String?=nil}
struct Screen {var group:String;var id:String;var title:String;var status:String;var items:[Item];var primary:String;var secondary:String="Geri";var kind:String="panels";var disabled=false}
let suite=read("design/states/D1-D6-screen-fixtures.json")
var screens:[Screen]=[]
for raw in suite["screens"] as! [[String:Any]] {screens.append(Screen(group:raw["group"] as! String,id:raw["id"] as! String,title:raw["title"] as! String,status:raw["status"] as! String,items:(raw["items"] as! [[String:String]]).map{Item(title:$0["title"]!,body:$0["body"]!,icon:$0["icon"])},primary:raw["primary"] as! String,secondary:raw["secondary"] as? String ?? "Geri",kind:raw["kind"] as? String ?? "panels",disabled:raw["disabled"] as? Bool ?? false))}
var verification:[[String:Any]]=[]
let m=g("margin"),gap=g("gap"),pad=g("inset"),target=g("target")
func control(_ title:String,_ r:CGRect,_ active:Bool=true){frame(r);if active {box(CGRect(x:r.minX+g("frameEdge"),y:r.minY+g("frameEdge"),width:r.width-2*g("frameEdge"),height:r.height-2*g("frameEdge")),"nav")};paint(title,"label",r.minX+pad,r.minY+pad/2,r.width-2*pad,active ? "paper":"nav")}

let variants=read("design/states/D2-services-v11-fixtures.json")["variants"] as! [[String:Any]]
for v in variants {
 let id=v["id"] as! String, title=v["title"] as! String,status=v["status"] as! String
 let w=g("width"),h=g("height"),cw=(w-2*m-gap)/2
 let headerY=g("safeTop"),headerH=max(target,shape(title,"screenTitle",w-2*m-2*pad).height+pad)
 let statusY=headerY+headerH+gap,statusH=shape(status,"supporting",w-2*m-2*pad).height+pad
 let top=statusY+statusH+gap, actionY=h-g("safeBottom")-target, bottom=actionY-gap
 var checks:[[String:Any]]=[]
 let path="\(out)/\(id).png"
 save(bitmap(Int(w),Int(h)){
 box(CGRect(x:0,y:0,width:w,height:h),"nav")
 frame(CGRect(x:m,y:headerY,width:w-2*m,height:headerH));paint(title,"screenTitle",m+pad,headerY+pad/2,w-2*m-2*pad)
 box(CGRect(x:m,y:statusY,width:w-2*m,height:statusH),"paper");paint(status,"supporting",m+pad,statusY+pad/2,w-2*m-2*pad)
 for (i,key) in ["left","right"].enumerated(){
 let x=m+CGFloat(i)*(cw+gap),lines=v[key] as! [String]
 frame(CGRect(x:x,y:top,width:cw,height:bottom-top))
 artCell(8+i,CGRect(x:x+pad,y:top+pad,width:target,height:target))
 let tw=cw-target-3*pad,th=shape(lines[0],"sectionTitle",tw).height
 paint(lines[0],"sectionTitle",x+target+2*pad,top+pad,tw)
 var y=top+max(target,th)+pad
 for text in lines.dropFirst(){let s=shape(text,"body",cw-2*pad);paint(text,"body",x+pad,y,cw-2*pad);y+=s.height}
 checks.append(["pane":key,"contentBottom":y,"availableBottom":bottom-pad,"allFit":y<=bottom-pad])
 }
 let label=v["primary"] as! String, enabled=v["enabled"] as! Bool
 control(label,CGRect(x:m,y:actionY,width:cw,height:target),enabled)
 control("← Geri",CGRect(x:m+cw+gap,y:actionY,width:cw,height:target))
 checks.append(["pane":"action","allFit":shape(label,"label",cw-2*pad).height+pad<=target])
 },path)
 verification.append(["screen":"D2/services/"+id,"path":path,"allFit":checks.allSatisfy{$0["allFit"] as! Bool},"checks":checks,"minimumActionTargetPx":target])
}
// Separate mode pickers expose full-size selection targets instead of treating text as controls.
for (id,name,road,term) in [("guide","Bələdçi",4,12),("guard","Mühafizəçi",10,28)] {
 let w=g("width"),h=g("height"),cw=(w-2*m-gap)/2,top=g("safeTop")+target+gap
 let path="\(out)/select-\(id).png"
 let labels=["Bir yol · \(road) qızıl","4 gün · \(term) qızıl","Seçimi sil","← Digər xidmət"]
 var fits=true
 save(bitmap(Int(w),Int(h)){
 box(CGRect(x:0,y:0,width:w,height:h),"nav")
 frame(CGRect(x:m,y:g("safeTop"),width:w-2*m,height:target))
 paint(name+" · Müqavilə seç","screenTitle",m+pad,g("safeTop")+pad/2,w-2*m-2*pad)
 for (i,label) in labels.enumerated(){let x=m+CGFloat(i%2)*(cw+gap),y=top+CGFloat(i/2)*(target+gap)
 control(label,CGRect(x:x,y:y,width:cw,height:target))
 fits = fits && shape(label,"label",cw-2*pad).height+pad<=target
 }
 let noteY=top+2*(target+gap)
 let note="Seçim ödəniş deyil. Əhatə aktivdirsə yeni müqavilə bağlıdır."
 frame(CGRect(x:m,y:noteY,width:w-2*m,height:target));paint(note,"supporting",m+pad,noteY+pad/2,w-2*m-2*pad)
 fits = fits && shape(note,"supporting",w-2*m-2*pad).height+pad<=target && noteY+target+gap<=h-g("safeBottom")-target
 control("Seçimə qayıt",CGRect(x:m,y:h-g("safeBottom")-target,width:w-2*m,height:target))
 },path)
 verification.append(["screen":"D2/services/select-"+id,"path":path,"allFit":fits,"minimumActionTargetPx":target])
}
let result:[String:Any]=["captures":verification,"missingGlyphs":missing,"allFit":verification.allSatisfy{$0["allFit"] as! Bool},"gameCodeChanged":false,"scope":"D2 service static AZ P1 1x only; no runtime proof"]
try! JSONSerialization.data(withJSONObject:result,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(out)/verification.json"))
print("captures=\(verification.count) missing=\(missing) allFit=\(verification.allSatisfy{$0["allFit"] as! Bool})")
