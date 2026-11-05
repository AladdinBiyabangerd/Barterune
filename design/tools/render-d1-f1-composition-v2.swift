// Static composition experiment only. No app/game implementation.
import AppKit
import CoreText
import CryptoKit
func read(_ p:String)->[String:Any]{try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:p))) as! [String:Any]}
let dir="design/states/D1-F1-composition-v2"
try! FileManager.default.createDirectory(atPath:dir,withIntermediateDirectories:true)
let matrix=read("design/states/D1-canonical-render-matrix.json")
let roles=(matrix["typeTrial"] as! [String:Any])["roles"] as! [String:[String:Int]]
let fixture=read("design/states/D1-render-fixture.json"), manifest=read("design/states/D1-font-binary-manifest.json")
let base=fixture["base"] as! [String:Any], goods=base["goods"] as! [[String:Any]]
let loc=(read("design/states/D1-render-localization.json")["strings"] as? [String:[String:String]])
let localization=read("design/states/D1-render-localization.json")
let strings=(localization["languages"] as? [String:[String:String]]) ?? loc ?? [:]
let ru=strings["RU"]!
let refs=read("design/states/D6-canonical-token-proposal.json")["referenceColors"] as! [String:[String:String]]
func color(_ k:String)->NSColor{let v=UInt32(refs[k]!["value"]!.dropFirst(),radix:16)!;return NSColor(srgbRed:CGFloat((v>>16)&255)/255,green:CGFloat((v>>8)&255)/255,blue:CGFloat(v&255)/255,alpha:1)}
func t(_ k:String,_ values:[String:String]=[:])->String{var s=ru[k]!;for(k,v) in values{s=s.replacingOccurrences(of:"{\(k)}",with:v)};return s}
var fonts:[String:CTFont]=[:], fontEvidence:[[String:Any]]=[]
for f in manifest["fonts"] as! [[String:Any]] {
 let data=try! Data(contentsOf:URL(fileURLWithPath:f["path"] as! String));let hash=SHA256.hash(data:data).map{String(format:"%02x",$0)}.joined();precondition(hash==f["sha256"] as! String)
 let cg=CGFont(CGDataProvider(data:data as CFData)!)!
 for w in [400,600,700]{let variation:[NSNumber:NSNumber]=[NSNumber(value:0x77676874):NSNumber(value:w),NSNumber(value:0x77647468):100]
 let desc=CTFontDescriptorCreateWithAttributes([kCTFontVariationAttribute:variation] as CFDictionary)
 let font=CTFontCreateWithGraphicsFont(cg,64,nil,desc);fonts["\(f["id"]!)-\(w)"]=font
 fontEvidence.append(["source":f["path"]!,"sha256":hash,"requestedWeight":w,"requestedWidth":100,"resolvedName":CTFontCopyPostScriptName(font),"resolvedAxes":Dictionary(uniqueKeysWithValues: (CTFontCopyVariation(font) as? [NSNumber:NSNumber] ?? [:]).map{ (String($0.key.intValue), $0.value.doubleValue) })])
 }
}
struct Row{let text:String;let role:String;var button=false;var pair:String?=nil}
var runs=Set<String>(), evidence:[[String:Any]]=[]
func font(_ role:String,_ candidate:String)->CTFont{let r=roles[role]!;let family=(candidate=="F2" && ["screenTitle","sectionTitle"].contains(role)) ? "NotoSerif":"NotoSans";return CTFontCreateCopyWithAttributes(fonts["\(family)-\(r["weight"]!)"]!,CGFloat(r["sizeSp"]!*4),nil,nil)}
func lines(_ s:String,_ role:String,_ candidate:String,_ width:CGFloat)->[(CTLine,CGFloat)]{
 let f=font(role,candidate), a=NSAttributedString(string:s,attributes:[.font:f,.foregroundColor:color("nav")]);let ts=CTTypesetterCreateWithAttributedString(a);var i=0;var result:[(CTLine,CGFloat)]=[]
 while i<a.length{let n=CTTypesetterSuggestLineBreak(ts,i,Double(width));precondition(n>0);let line=CTTypesetterCreateLine(ts,CFRange(location:i,length:n));result.append((line,CGFloat(roles[role]!["lineHeightSp"]!*4)));i+=n
 for run in CTLineGetGlyphRuns(line) as! [CTRun]{let attr=CTRunGetAttributes(run) as NSDictionary;let resolved=attr[kCTFontAttributeName] as! CTFont;runs.insert(CTFontCopyPostScriptName(resolved) as String)}
 };return result
}
func rows(_ mode:String)->[Row]{
 var r=[Row(text:t("market")+" · "+t("city"),role:"screenTitle"),Row(text:t("current"),role:"sectionTitle"),Row(text:t("day",["day":"4","totalDays":"20"])+" · "+t("gold")+" 500 · "+t("load")+" 16/40",role:"numeric")]
 if mode != "detail"{r += [Row(text:t("goods")+" · "+t(mode=="cards" ? "cards":"list"),role:"sectionTitle")];for g in goods{let id=g["id"] as! String;r.append(Row(text:t(id)+(id=="cloth" ? " · "+t("selected"):""),role:"sectionTitle"));for(k,v) in [("buyUnit",g["buyUnit"]!),("sellUnit",g["sellUnitUndamaged"]!),("stock",g["stock"]!),("owned",id=="cloth" ? 8:0),("unitLoad",g["unitLoad"]!)]{r.append(Row(text:t(k)+": \(v)",role:"body"))};r.append(Row(text:t("openDetails",["good":t(id)]),role:"label",button:true))};return r}
 r += [Row(text:t("backToMarket"),role:"label",button:true),Row(text:t("cloth"),role:"sectionTitle")]
 for(k,v) in [("buyUnit","35"),("sellUnit","28"),("stock","30"),("owned","8"),("unitLoad","2")]{r.append(Row(text:t(k)+": "+v,role:"body"))}
 r.append(Row(text:t("batches"),role:"sectionTitle"))
 for(quality,count,cost,name) in [(100,5,24,"healthy"),(60,3,20,"damaged")]{r += [Row(text:t(name)+" · "+t(quality==100 ? "selected":"unselected"),role:"label"),Row(text:t("quality",["quality":"\(quality)"])+" · "+t("batchCount",["count":"\(count)"]),role:"body"),Row(text:t("averageCost")+": \(cost)",role:"body")];if quality==100{r.append(Row(text:t("margin")+": 4",role:"body"))}}
 r += [Row(text:t("marginNote"),role:"supporting"),Row(text:t("quantity")+": 2",role:"sectionTitle"),Row(text:t("buyMax",["max":"12"]),role:"label",button:true),Row(text:t("sellMax",["max":"5"]),role:"label",button:true),Row(text:t("maxNote"),role:"supporting")]
 for(key,total,gold,load) in [("buyPreview","buyTotal",430,20),("sellPreview","sellTotal",556,12)]{r += [Row(text:t(key),role:"sectionTitle"),Row(text:t(total,["total":key=="buyPreview" ? "70":"56"]),role:"numeric"),Row(text:t("gold")+": \(gold) · "+t("load")+": \(load)/40",role:"numeric")]}
 r.append(Row(text:t("buyAmount",["total":"70"]),role:"label",button:true,pair:t("sellAmount",["total":"56"])));return r
}
func image(_ w:Int,_ h:Int,_ draw:(CGContext)->Void)->NSBitmapImageRep{let b=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:w,pixelsHigh:h,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!;NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:b);let c=NSGraphicsContext.current!.cgContext;c.translateBy(x:0,y:CGFloat(h));c.scaleBy(x:1,y:-1);draw(c);NSGraphicsContext.restoreGraphicsState();return b}
func save(_ b:NSBitmapImageRep,_ path:String){try! b.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:path))}

struct Block { let s:String; let role:String; let x:CGFloat; let y:CGFloat; let w:CGFloat; let h:CGFloat; var action=false }
var checks:[[String:Any]]=[]
func draw(_ name:String,_ blocks:[Block]) {
 let bitmap=image(1280,720){c in
 color("paper").setFill();NSRect(x:0,y:0,width:1280,height:720).fill()
 for b in blocks {
 let ll=lines(b.s,b.role,"F1",b.w-32);let needed=ll.reduce(CGFloat(0)){$0+$1.1}+16
 checks.append(["capture":name,"text":b.s,"role":b.role,"rectPx":[b.x,b.y,b.w,b.h],"neededHeightPx":needed,"fits":needed<=b.h,"safe":b.x>=0 && b.y>=48 && b.x+b.w<=1280 && b.y+b.h<=672])
 if b.action{color("nav").setFill();NSRect(x:b.x,y:b.y,width:b.w,height:b.h).fill()}
 var y=b.y+8
 for(line,lh) in ll {let range=CTLineGetStringRange(line);let sub=(b.s as NSString).substring(with:NSRange(location:range.location,length:range.length));let attr=NSAttributedString(string:sub,attributes:[.font:font(b.role,"F1"),.foregroundColor:color(b.action ? "paper":"nav")]);c.saveGState();c.translateBy(x:b.x+16,y:y+CTFontGetAscent(font(b.role,"F1")));c.scaleBy(x:1,y:-1);c.textPosition = .zero;CTLineDraw(CTLineCreateWithAttributedString(attr),c);c.restoreGState();y+=lh}
 }
 };save(bitmap,"\(dir)/\(name).png")
}
func b(_ s:String,_ role:String,_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ h:CGFloat,_ action:Bool=false)->Block{Block(s:s,role:role,x:x,y:y,w:w,h:h,action:action)}
// Route-local return control replaces global navigation only in this experiment.
let hud=b(t("day",["day":"4","totalDays":"20"])+" · "+t("gold")+" 500 · "+t("load")+" 16/40","numeric",16,48,1248,112)
// Name-only selector: detailed fields remain in the separate selected-good route.
for page in 0..<3 {
 var blocks=[b(t("goods")+" · \(page+1)/3","sectionTitle",16,48,800,112),b(t("back"),"label",928,48,336,112,true)]
 let range=page*4..<min(page*4+4,goods.count)
 for(i,index) in range.enumerated(){let g=goods[index];let id=g["id"] as! String;blocks.append(b(t(id)+(id=="cloth" ? " · "+t("selected"):""),"label",16+CGFloat(i%2)*632,168+CGFloat(i/2)*232,616,216,true))}

 draw("list-\(page+1)",blocks)
}
// C1 summary: all preview outcomes and HUD together, full detail remains separate.
var summary=[hud,b(t("cloth")+" · "+t("quantity")+" 2","label",16,160,1248,112)]
for(i,values) in [("После покупки · 2 × 35 = 70",430,20),("После продажи · 2 × 28 = 56",556,12)].enumerated(){let x:CGFloat=16+CGFloat(i)*632
 summary += [b(values.0,"supporting",x,272,616,176),b(t("gold")+" \(values.1)","numeric",x,448,616,112),b(t("load")+" \(values.2)/40","numeric",x,560,616,112)]}
draw("C1-summary",summary)
// C2 separates quantity adjustment from economic execution with explicit labels.
draw("C2-actions",[b(t("cloth")+" · "+t("quantity")+" 2","label",16,48,1248,112),b(t("buyMax",["max":"12"]),"label",16,168,616,208,true),b(t("sellMax",["max":"5"]),"label",648,168,616,208,true),b(t("maxNote"),"supporting",16,392,1248,96),b(t("buyAmount",["total":"70"]),"label",16,496,616,112,true),b(t("sellAmount",["total":"56"]),"label",648,496,616,112,true)])
// Full detail uses finite sections, not one 2208dp scrolling document.
let sections:[[String]]=[
 [t("buyUnit")+": 35",t("sellUnit")+": 28",t("stock")+": 30",t("owned")+": 8",t("unitLoad")+": 2"],
 [t("healthy")+" · "+t("selected"),t("quality",["quality":"100"])+" · "+t("batchCount",["count":"5"]),t("averageCost")+": 24",t("margin")+": 4",t("marginNote")],
 [t("damaged")+" · "+t("unselected"),t("quality",["quality":"60"])+" · "+t("batchCount",["count":"3"]),t("averageCost")+": 20"]]
let fieldPages = sections.flatMap { fields in stride(from:0,to:fields.count,by:4).map { Array(fields[$0..<min($0+4,fields.count)]) } }
for(i,ss) in fieldPages.enumerated(){var blocks=[b(t("cloth")+" · \(i+1)/\(fieldPages.count)","sectionTitle",16,48,1248,112)]
 var yy:CGFloat=160
 for text in ss{let role=text==t("marginNote") ? "supporting":"body";let h=CGFloat(lines(text,role,"F1",1216).count)*CGFloat(roles[role]!["lineHeightSp"]!*4)+16;blocks.append(b(text,role,16,yy,1248,h));yy+=h}
 draw("detail-\(i+1)",blocks)
}
let output:[String:Any]=["scope":"F1 P1 RU2x static composition v2 only; not app implementation","fonts":fontEvidence,"resolvedRunNames":Array(runs).sorted(),"checks":checks,"geometry":"Named trial only: padding8dp/gap8dp, square corners; source canonical dimensions remain null","draftRussianLabels":["Покупка · 2 × 35 = 70","Продажа · 2 × 28 = 56"],"responsiveness":"All D1–D5 screens must adapt to viewport/insets/fontScale/language. This P1 static result is not global responsive validation. Measure content; no shrinking or hidden critical data. Reflow/section navigation when minimum content widths fail; no production breakpoint chosen."]
try! JSONSerialization.data(withJSONObject:output,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(dir)/manifest.json"))
print("blocks \(checks.count), failures \(checks.filter{!($0["fits"] as! Bool) || !($0["safe"] as! Bool)}.count)")
