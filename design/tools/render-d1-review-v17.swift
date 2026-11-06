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


let out="design/states/D1-review-v17"
let ids=["cloth","grain","wood","spices","iron","salt","wool","herbs","mana_crystal","dragon_resin"]
let names=["Parça","Taxıl","Odun","Ədviyyat","Dəmir","Duz","Yun","Otlar","Mana kristalı","Əjdaha qatranı"]
var captures:[String]=[]
func emit(_ name:String,_ w:Int,_ h:Int,_ draw:()->Void){save(bitmap(w,h,draw),"\(out)/\(name).png");captures.append(name+".png")}
func icon(_ id:String,_ r:CGRect){let im=NSImage(contentsOfFile:"core/designsystem/src/main/res/drawable-nodpi/good_\(id).png")!.cgImage(forProposedRect:nil,context:nil,hints:nil)!;let c=NSGraphicsContext.current!.cgContext;c.saveGState();c.interpolationQuality = .none;c.translateBy(x:r.minX,y:r.maxY);c.scaleBy(x:1,y:-1);c.draw(im,in:CGRect(origin:.zero,size:r.size));c.restoreGState()}
// Icon list and cards at native profile dimensions, with explicit scroll pages.
let profiles=read("design/states/D1-canonical-render-matrix.json")["profiles"] as! [[String:Any]]
for p in profiles {let pid=p["id"] as! String,px=p["outputPx"] as! [Int],d=p["density"] as! Int;let f=CGFloat(d)/2,w=CGFloat(px[0])/f,h=CGFloat(px[1])/f,s=p["safeInsetsDp"] as! [String:Int];let x=CGFloat(s["left"]!*2)+g("margin"),y=CGFloat(s["top"]!*2),width=w-x-g("margin"),bottom=h-CGFloat(s["bottom"]!*2);let row=g("target")+g("gap");let count=max(1,Int((bottom-y-row)/row))
for style in ["list","cards"] {for start in stride(from:0,to:10,by:count) {emit("\(pid)-icons-\(style)-scroll-\(start/count)",px[0],px[1]){NSGraphicsContext.current!.cgContext.scaleBy(x:f,y:f);box(CGRect(x:0,y:0,width:w,height:h),"nav");frame(CGRect(x:x,y:y,width:width,height:bottom-y));paint("Bazar · Qızıl 500","label",x+g("inset"),y+g("inset"),width-2*g("inset"));for i in start..<min(start+count,10){let yy=y+row+CGFloat(i-start)*row;icon(ids[i],CGRect(x:x+g("inset"),y:yy,width:g("target"),height:g("target")));paint(names[i],"label",x+g("inset")+row,yy,width-row-2*g("inset"));if style=="cards"{paint("Malı aç →","supporting",x+g("inset")+row,yy+48,width-row-2*g("inset"))}}}}}
}
// Tablet bounded master-detail proposals: all four languages and font scales.
let localizations=read("design/states/D1-render-localization.json")["languages"] as! [String:[String:String]]
let headings=["AZ":("Bazar","Parça","← Bazara qayıt"),"EN":("Market","Cloth","← Back to market"),"RU":("Рынок","Ткань","← Вернуться на рынок"),"TR":("Pazar","Kumaş","← Pazara dön")]
for lang in ["AZ","EN","RU","TR"] {for fs in [1.0,1.3,2.0] {scale=fs;let t=headings[lang]!;emit("P3-\(lang)-\(fs)x-master-detail",2560,1600){box(CGRect(x:0,y:0,width:2560,height:1600),"nav");let pane=g("maxTextWidth"),left=(2560-2*pane-g("gap"))/2,top=g("safeTop"),height=1600-g("safeTop")-g("safeBottom");for x in [left,left+pane+g("gap")]{frame(CGRect(x:x,y:top,width:pane,height:height))};paint(t.0,"screenTitle",left+g("inset"),top+g("inset"),pane-2*g("inset"));var yy=top+160;for i in 0..<7{icon(ids[i],CGRect(x:left+g("inset"),y:yy,width:g("target"),height:g("target")));paint(localizations[lang]![ids[i]]!,"body",left+g("inset")+120,yy,pane-160);yy+=max(144,shape(localizations[lang]![ids[i]]!,"body",pane-160).height+g("gap"))};let rx=left+pane+g("gap")+g("inset"),rw=pane-2*g("inset");paint(t.1,"screenTitle",rx,top+g("inset"),rw);icon("cloth",CGRect(x:rx,y:top+180,width:g("target")*2,height:g("target")*2));paint("500 · 16 / 40","numeric",rx,top+420,rw);paint(t.2,"label",rx,top+640,rw);paint(localizations[lang]!["buy"]!+" / "+localizations[lang]!["sell"]!,"body",rx,top+920,rw)}}}
scale=1
// Schematic storyboard uses existing palette and type; no final new screen art.
for pid in ["P1","P3"] {for (kind,times) in [("travel",[0,200,600,800]),("day",[0,80,160,240]),("trade",[0,60,120,180])] {emit("\(pid)-\(kind)-storyboard",1280,720){box(CGRect(x:0,y:0,width:1280,height:720),"paper");paint("\(pid) · \(kind) · motion proposal","screenTitle",24,24,1232);for i in 0..<4{let x=CGFloat(i)*312+24;paint("\(times[i]) ms","label",x,140,288);paint(["pending","transition","committed","stable"][i],"body",x,230,288);if kind=="travel"{box(CGRect(x:x,y:428,width:264,height:6),"nav");box(CGRect(x:x+CGFloat(i)*48,y:380,width:48,height:48),"ink")}else{paint(kind=="day" ? (i<2 ? "Gün 1":"Gün 2"):(i<2 ? "…":"✓"),"screenTitle",x,380,288)}};paint("Sxematik yol markeridir; final araba deyil. Az hərəkət: 0 ms.","supporting",24,620,1232)}}}
let report:[String:Any] = ["captures":captures,"missingGlyphs":missing,"status":"static_review_candidate","limits":["tablet sample only; not all transaction states", "storyboard is schematic; no runtime animation", "linear font scaling only", "icon card/list labels AZ only"]]
let dataOut=try! JSONSerialization.data(withJSONObject:report,options:[.prettyPrinted,.sortedKeys]);try! dataOut.write(to:URL(fileURLWithPath:out+"/verification.json"));print("captures=\(captures.count), missingGlyphs=\(missing)")
