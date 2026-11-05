// Static composition experiment only. No app/game implementation.
import AppKit
import CoreText
import CryptoKit
func read(_ p:String)->[String:Any]{try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:p))) as! [String:Any]}
let dir="design/states/D1-F1-P1-C1-v5"
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

// Measurement first: aligned label/value rows, parallel batches, separate previews.
// Reuse v3/v4 trial padding/gaps; no canonical dimension decision.
var measured:[[String:Any]]=[]
var blocks:[Block]=[]
func cell(_ text:String,_ role:String,_ x:CGFloat,_ y:CGFloat,_ width:CGFloat)->CGFloat {
 let count=lines(text,role,"F1",width-32).count
 let height=CGFloat(count*roles[role]!["lineHeightSp"]!*4+16)
 measured.append(["text":text,"role":role,"lineCount":count,"heightPx":height,"widthPx":width,"x":x,"y":y])
 blocks.append(b(text,role,x,y,width,height))
 return height
}
func pair(_ key:String,_ value:String,_ role:String,_ x:CGFloat,_ y:CGFloat,_ width:CGFloat)->CGFloat {
 // Measure candidate label allocations; retain full strings and role on both cells.
 var best=CGFloat.greatestFiniteMagnitude, bestW:CGFloat=0
 for percentage in stride(from:50,through:90,by:5) {
 let lw=(width-16)*CGFloat(percentage)/100, rw=width-16-lw
 let left=lines(key,role,"F1",lw-32).count, right=lines(value,role,"F1",rw-32).count
 let h=CGFloat(max(left,right)*roles[role]!["lineHeightSp"]!*4+16)
 if h<best{best=h;bestW=lw}
 }
 _=cell(key,role,x,y,bestW)
 _=cell(value,role,x+bestW+16,y,width-bestW-16)
 return best
}
var sections:[[String:Any]]=[]
var y:CGFloat=48
let listH=cell(t("grain"),"label",16,y,304)
let hud=t("day",["day":"4","totalDays":"20"])+" · "+t("gold")+" 500 · "+t("load")+" 16/40"
let hudH=cell(hud,"numeric",336,y,928)
y += max(listH,hudH)+16
sections.append(["section":"list_start_and_HUD","heightPx":max(listH,hudH)])
let headerH=cell(t("cloth")+" · "+t("quantity")+" 2","body",16,y,1248)
y += headerH+16
let metricStart=y
for (key,value) in [("buyUnit","35"),("sellUnit","28"),("stock","30"),("owned","8"),("unitLoad","2")] {
 y += pair(t(key)+":",value,"body",16,y,1248)
}
sections.append(["section":"aligned_good_metrics","heightPx":y-metricStart])
y += 16
let batchStart=y
var batchEnds:[CGFloat]=[]
for (index,name,quality,count,cost,state) in [(0,"healthy","100","5","24","selected"),(1,"damaged","60","3","20","unselected")] {
 let x=CGFloat(16+index*632);var by=y
 by += cell(t(name)+" · "+t(state),"body",x,by,616)
 by += cell(t("quality",["quality":quality]),"body",x,by,616)
 by += cell(t("batchCount",["count":count]),"body",x,by,616)
 by += pair(t("averageCost")+":",cost,"body",x,by,616)
 if index==0{by += pair(t("margin")+":","4","body",x,by,616)}
 batchEnds.append(by)
}
y=batchEnds.max()!
sections.append(["section":"parallel_batches","heightPx":y-batchStart])
y += cell(t("marginNote"),"supporting",16,y,1248)+16
let previewStart=y
var previewEnds:[CGFloat]=[]
for (index,key,total,gold,load) in [(0,"buyPreview","70","430","20"),(1,"sellPreview","56","556","12")] {
 let x=CGFloat(16+index*632);var py=y
 py += cell(t(key),"label",x,py,616)
 py += cell(t(index==0 ? "buyTotal":"sellTotal",["total":total]),"numeric",x,py,616)
 py += pair(t("gold"),gold,"numeric",x,py,616)
 py += pair(t("load"),load+"/40","numeric",x,py,616)
 previewEnds.append(py)
}
y=previewEnds.max()!
sections.append(["section":"separate_parallel_previews","heightPx":y-previewStart])
let fits=y<=672
if fits {draw("P1-C1",blocks)}
let output:[String:Any]=["scope":"Only P1 C1 F1 RU2x, measured before optional render; no implementation","fonts":fontEvidence,"resolvedRunNames":Array(runs).sorted(),"captureContract":fixture["captureContract"]!,"blocks":measured,"sections":sections,"contentBottomPx":y,"safeTopPx":48,"safeBottomPx":672,"requiredHeightPx":y-48,"availableHeightPx":624,"fits":fits,"rendered":fits,"geometry":"Existing 16px trial gaps and block padding; metrics label/value split searched 50...90 percent in 5 percent steps; equal-width parallel batches/previews; no new canonical token","limitations":"One proposed composition measured; not an impossibility proof or live UI acceptance. Other profiles/languages/device checks remain open."]
try! JSONSerialization.data(withJSONObject:output,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(dir)/measurement.json"))
print("Required height \(y-48)px; available624px; fits \(fits); rendered \(fits)")
for section in sections{print(section)}
