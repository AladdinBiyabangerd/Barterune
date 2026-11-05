// Static composition experiment only. No app/game implementation.
import AppKit
import CoreText
import CryptoKit
func read(_ p:String)->[String:Any]{try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:p))) as! [String:Any]}
let dir="design/states/D1-C1-navigation-grouped-v3"
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
 let ll=lines(b.s,b.role,"F1",b.w-32);let needed=ll.reduce(CGFloat(0)){$0+$1.1}
 checks.append(["capture":name,"text":b.s,"role":b.role,"rectPx":[b.x,b.y,b.w,b.h],"neededHeightPx":needed,"fits":needed<=b.h,"safe":b.x>=0 && b.y>=48 && b.x+b.w<=CGFloat(width) && b.y+b.h<=CGFloat(height-48)])
 if b.action{color("nav").setFill();NSRect(x:b.x,y:b.y,width:b.w,height:b.h).fill()}
 var y=b.y
 for(line,lh) in ll {let range=CTLineGetStringRange(line);let sub=(b.s as NSString).substring(with:NSRange(location:range.location,length:range.length));let attr=NSAttributedString(string:sub,attributes:[.font:font(b.role,"F1"),.foregroundColor:color(b.action ? "paper":"nav")]);c.saveGState();c.translateBy(x:b.x+16,y:y+CTFontGetAscent(font(b.role,"F1")));c.scaleBy(x:1,y:-1);c.textPosition = .zero;CTLineDraw(CTLineCreateWithAttributedString(attr),c);c.restoreGState();y+=lh}
 }
 };save(bitmap,"\(dir)/\(name).png")
}
func b(_ s:String,_ role:String,_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ h:CGFloat,_ action:Bool=false)->Block{Block(s:s,role:role,x:x,y:y,w:w,h:h,action:action)}


let hud=t("day",["day":"4","totalDays":"20"])+" · "+t("gold")+" 500 · "+t("load")+" 16/40"
let identity=t("cloth")+" · "+t("quantity")+" 2"
let detail:[(String,String)]=[
 (identity,"body"),
 (t("buyUnit")+": 35 · "+t("sellUnit")+": 28","body"),
 (t("stock")+": 30 · "+t("owned")+": 8 · "+t("unitLoad")+": 2","body"),
 (t("healthy")+" · "+t("selected"),"body"),
 (t("quality",["quality":"100"])+" · "+t("batchCount",["count":"5"]),"body"),
 (t("averageCost")+": 24 · "+t("margin")+": 4","body"),
 (t("damaged")+" · "+t("unselected"),"body"),
 (t("quality",["quality":"60"])+" · "+t("batchCount",["count":"3"]),"body"),
 (t("averageCost")+": 20","body"),
 (t("marginNote"),"supporting")]
var previews:[(String,String)]=[]
for(key,total,gold,load) in [("buyPreview",70,430,20),("sellPreview",56,556,12)] {
 previews += [(t(key),"label"),(t(key=="buyPreview" ? "buyTotal":"sellTotal",["total":"\(total)"]),"numeric"),(t("gold")+" \(gold) · "+t("load")+" \(load)/40","numeric")]
}
let sections:[(String,String,[(String,String)])]=[
 ("list-start",t("goods"),[(t("grain"),"label")]),
 ("good",t("cloth"),Array(detail[1...2])),
 ("batch-healthy",detail[3].0,Array(detail[4...5])),
 ("batch-damaged",detail[6].0,Array(detail[7...8])),
 
 ("preview-buy",t("buyPreview"),Array(previews[1...2])),
 ("preview-sell",t("sellPreview"),Array(previews[4...5]))]
var pages:[[String:Any]]=[]
for (id,title,source) in sections {
 var header:[Block]=[], y:CGFloat=48
 // HUD remains at list start; detail frames retain identity and section context. Selected batch remains explicit in sell preview.
 var fixed:[(String,String)]=id == "list-start" ? [(hud,"numeric")] : []
 if id != "list-start" {fixed.append((identity,"body"))}
 
 if id == "batch-damaged" {fixed.append((t("batches"),"label"))}
 if id != "good" {fixed.append((title,id == "batch-healthy" || id == "batch-damaged" ? "body":"label"))}
 if id == "preview-sell" {fixed.append((t("healthy")+" · "+t("selected"),"body"))}
 for (text,role) in fixed {
  let h=CGFloat(lines(text,role,"F1",1216).count)*CGFloat(roles[role]!["lineHeightSp"]!*4)
  header.append(b(text,role,16,y,1248,h));y+=h
 }
 let contentTop=y, available=576-y
 precondition(available>=96,"Header leaves no content room")
 var fragments:[(String,String,Int,CGFloat)]=[]
 for (index,row) in source.enumerated() {
  for (line,lh) in lines(row.0,row.1,"F1",1216) {
   let range=CTLineGetStringRange(line)
   let sub=(row.0 as NSString).substring(with:NSRange(location:range.location,length:range.length))
   fragments.append((sub,row.1,index,lh))
  }
 }
 var index=0,page=0,offset:CGFloat=0
 while index<fragments.count {
  page+=1;var blocks=header;var yy=contentTop;let start=index;let startOffset=offset
  while index<fragments.count {
   let rowIndex=fragments[index].2
   let remainingRow=fragments[index...].prefix{ $0.2 == rowIndex }.reduce(CGFloat(0)){ $0+$1.3 }
   if index>start && remainingRow<=available && yy+remainingRow>576 {break}
   let (text,role,_,lh)=fragments[index];let h=lh
   if yy+h>576 {break}
   blocks.append(b(text,role,16,yy,1248,h));yy+=h;offset+=h;index+=1
  }
  precondition(index>start,"No fragment fits")
  if id == "batch-healthy" && index == fragments.count {
   let last=blocks.removeLast()
   let line=lines(last.s,last.role,"F1",last.w-32)[0].0
   let used=CGFloat(CTLineGetTypographicBounds(line,nil,nil,nil))
   let leftWidth=ceil(used)+32
   let noteX=last.x+leftWidth
   let noteWidth=1264-noteX
   let noteLines=lines(detail[9].0,detail[9].1,"F1",noteWidth-32)
   print("Inline margin note: remaining text width \(noteWidth-32), note lines \(noteLines.count)")
   precondition(noteLines.count == 1,"Margin note does not fit inline")
   blocks.append(b(last.s,last.role,last.x,last.y,leftWidth,last.h))
   blocks.append(b(detail[9].0,detail[9].1,noteX,last.y,noteWidth,CGFloat(roles[detail[9].1]!["lineHeightSp"]!*4)))
  }
  let labels:[String]
  switch id {
   case "list-start": labels=["Ткань →"]
   case "good": labels=["Назад", "Партии", "Предпросмотр"]
   case "batch-healthy": labels=["Назад", "Партия →", "Предпросмотр"]
   case "batch-damaged": labels=["Назад"]
   default: labels=["Назад", "Покупка", "Продажа"]
  }
  // Static geometry derived from existing capture inset, label line-height and safe bottom.
  let gap:CGFloat=16, bw=(1248-gap*CGFloat(labels.count-1))/CGFloat(labels.count)
  let widths:[CGFloat] = (id == "good" || id == "batch-healthy") ? [300,396,520] : Array(repeating:bw,count:labels.count)
  var navX:CGFloat=16
  for (j,label) in labels.enumerated(){blocks.append(b(label,"label",navX,576,widths[j],96,true));navX+=widths[j]+gap}
  let name="C1-\(id)-\(page)";draw(name,blocks)
  pages.append(["capture":name,"section":id,"page":page,"outputPx":[1280,720],"contentTopPx":contentTop,"measuredContentOffsetPx":startOffset,"fragmentRange":[start,index],"sourceRows":(source + (id == "batch-healthy" ? [detail[9]]:[])).map{["text":$0.0,"role":$0.1]},"state":["selectedGood":"cloth","selectedBatch":"cloth-healthy","quantity":"2","gold":"500","load":"16/40"],"note":"Measured static content pagination, not live scroll/navigation evidence"])
 }
}
let output:[String:Any]=["scope":"Approved sectioned C1; P1 F1 RU2x static trial only; no game implementation","fonts":fontEvidence,"resolvedRunNames":Array(runs).sorted(),"checks":checks,"pages":pages,"captureContract":fixture["captureContract"]!,"geometry":"Existing 16px horizontal inset; contiguous measured text flow without per-line vertical padding; not canonical tokens","limitations":["No live navigation, focus/scroll restoration or selected state persistence test","No C2 changes or rerender","List start crop only; all ten goods reachability untested","No device/native Android scaling or global responsiveness claim","Grouping trial: current HUD shown at list start rather than repeated on detail frames. Navigation reserves y576…672; content paginated without shrinking. Trial geometry only, not canonical spacing tokens. Russian navigation labels are draft. List shortcut opens already selected cloth; full list reachability unproven. Preview tabs replace sibling preview; Back pops to opener, not sibling. Pagination represents scroll positions, not additional history entries."]]
try! JSONSerialization.data(withJSONObject:output,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(dir)/manifest.json"))
print("Captures \(pages.count); checks \(checks.count); failures \(checks.filter{!($0["fits"] as! Bool) || !($0["safe"] as! Bool)}.count)")
let board=image(2560,2160){c in
 for (i,p) in pages.enumerated(){
 let name=p["capture"] as! String
 let im=NSImage(contentsOfFile:"\(dir)/\(name).png")!;var r=CGRect(x:0,y:0,width:1280,height:720)
 let cg=im.cgImage(forProposedRect:&r,context:nil,hints:nil)!
 c.saveGState();c.translateBy(x:CGFloat(i%2)*1280,y:CGFloat(i/2+1)*720);c.scaleBy(x:1,y:-1);c.draw(cg,in:CGRect(x:0,y:0,width:1280,height:720));c.restoreGState()
 }
};save(board,"\(dir)/navigation.png")
