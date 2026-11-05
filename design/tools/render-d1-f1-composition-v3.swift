// Static composition experiment only. No app/game implementation.
import AppKit
import CoreText
import CryptoKit
func read(_ p:String)->[String:Any]{try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:p))) as! [String:Any]}
let dir="design/states/D1-F1-composition-v3"
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
func draw(_ name:String,_ blocks:[Block],_ width:Int=1280,_ height:Int=720) {
 let bitmap=image(width,height){c in
 color("paper").setFill();NSRect(x:0,y:0,width:CGFloat(width),height:CGFloat(height)).fill()
 for b in blocks {
 let ll=lines(b.s,b.role,"F1",b.w-32);let needed=ll.reduce(CGFloat(0)){$0+$1.1}+16
 checks.append(["capture":name,"text":b.s,"role":b.role,"rectPx":[b.x,b.y,b.w,b.h],"neededHeightPx":needed,"fits":needed<=b.h,"safe":b.x>=0 && b.y>=48 && b.x+b.w<=CGFloat(width) && b.y+b.h<=CGFloat(height-48)])
 if b.action{color("nav").setFill();NSRect(x:b.x,y:b.y,width:b.w,height:b.h).fill()}
 var y=b.y+8
 for(line,lh) in ll {let range=CTLineGetStringRange(line);let sub=(b.s as NSString).substring(with:NSRange(location:range.location,length:range.length));let attr=NSAttributedString(string:sub,attributes:[.font:font(b.role,"F1"),.foregroundColor:color(b.action ? "paper":"nav")]);c.saveGState();c.translateBy(x:b.x+16,y:y+CTFontGetAscent(font(b.role,"F1")));c.scaleBy(x:1,y:-1);c.textPosition = .zero;CTLineDraw(CTLineCreateWithAttributedString(attr),c);c.restoreGState();y+=lh}
 }
 };save(bitmap,"\(dir)/\(name).png")
}
func b(_ s:String,_ role:String,_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ h:CGFloat,_ action:Bool=false)->Block{Block(s:s,role:role,x:x,y:y,w:w,h:h,action:action)}

// Same F1 RU2x type. Geometry is a static trial, not canonical tokens.
// Independent list/detail scroll: C2 list is at its final item.
let endList=b(t("dragon_resin"),"label",16,48,400,304,true)
draw("P1-C2",[endList,
 b(t("cloth"),"label",16,352,400,112),
 b(t("quantity"),"supporting",16,464,400,96),b("2","numeric",16,560,400,112),
 b(t("buyMax",["max":"12"]),"label",432,48,408,304,true),
 b(t("sellMax",["max":"5"]),"label",856,48,408,304,true),
 b(t("maxNote"),"supporting",432,352,832,96),
 b(t("buyAmount",["total":"70"]),"label",432,464,408,208,true),
 b(t("sellAmount",["total":"56"]),"label",856,464,408,208,true)])
// C1 complete selected-good content; source labels retained (no abbreviations).
let detail:[String]=[
 t("cloth")+" · "+t("quantity")+" 2",
 t("buyUnit")+": 35 · "+t("sellUnit")+": 28",
 t("stock")+": 30 · "+t("owned")+": 8 · "+t("unitLoad")+": 2",
 t("healthy")+" · "+t("selected"),
 t("quality",["quality":"100"])+" · "+t("batchCount",["count":"5"]),
 t("averageCost")+": 24 · "+t("margin")+": 4",
 t("damaged")+" · "+t("unselected"),
 t("quality",["quality":"60"])+" · "+t("batchCount",["count":"3"]),
 t("averageCost")+": 20",
 t("marginNote")]
for (profile,width,height,listWidth) in [("P1",1280,720,304),("P3",2560,1600,448)] {
 var blocks=[b(t("grain"),"label",16,48,CGFloat(listWidth),208,true)]
 let x=CGFloat(listWidth+32), w=CGFloat(width-listWidth-48)
 blocks.append(b(t("day",["day":"4","totalDays":"20"])+" · "+t("gold")+" 500 · "+t("load")+" 16/40","numeric",x,48,w,112))
 let column=(w-16)/2
 var y:CGFloat=160
 for (i,text) in detail.enumerated(){let role=i==9 ? "supporting":"body";let h=CGFloat(lines(text,role,"F1",column-32).count)*CGFloat(roles[role]!["lineHeightSp"]!*4)+16
 blocks.append(b(text,role,x,y,column,h));y+=h}
 let px=x+column+16
 var py:CGFloat=168
 for (key,total,gold,load) in [("buyPreview",70,430,20),("sellPreview",56,556,12)] {
 for (text,role) in [(t(key),"label"),(t(key=="buyPreview" ? "buyTotal":"sellTotal",["total":"\(total)"]),"numeric"),(t("gold")+" \(gold) · "+t("load")+" \(load)/40","numeric")] {
 let h=CGFloat(lines(text,role,"F1",column-32).count)*CGFloat(roles[role]!["lineHeightSp"]!*4)+16
 blocks.append(b(text,role,px,py,column,h));py+=h
 };py+=16
 }
 draw("\(profile)-C1",blocks,width,height)
}
let output:[String:Any]=["scope":"F1 RU2x static v3 only; P1 C1/C2 and P3 C1; not game implementation","fonts":fontEvidence,"resolvedRunNames":Array(runs).sorted(),"checks":checks,"captureContract":fixture["captureContract"]!,"geometry":"Trial only: 8dp gap, square corners; canonical tokens unchanged","profiles":["P1:1280x720 safe y48...672","P3:2560x1600 safe y48...1552"],"scroll":"Static start/end list crops; no live scroll offsets measured. C1 grain=start, C2 dragon_resin=end. Selected cloth remains independent.","responsiveness":"Mandatory for all D1–D5 screens. No font shrinking or content removal. These static samples do not validate global responsiveness. P1 C1 overflow remains a blocker; P3 is not a substitute."]
try! JSONSerialization.data(withJSONObject:output,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(dir)/manifest.json"))
for name in ["P1-C1","P1-C2","P3-C1"]{let c=checks.filter{$0["capture"] as! String==name};print("\(name): \(c.count) blocks; failures \(c.filter{!($0["fits"] as! Bool) || !($0["safe"] as! Bool)}.count)")}
