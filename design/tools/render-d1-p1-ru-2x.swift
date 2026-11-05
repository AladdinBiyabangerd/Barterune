// Static composition experiment only. No app/game implementation.
import AppKit
import CoreText
import CryptoKit
func read(_ p:String)->[String:Any]{try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:p))) as! [String:Any]}
let dir="design/states/D1-P1-RU-2x"
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
for candidate in ["F1","F2"]{for mode in ["list","detail","cards"]{
 let rr=rows(mode);var y:CGFloat=16;var positions:[CGFloat]=[];var heights:[CGFloat]=[]
 for r in rr{positions.append(y);let width:CGFloat=r.pair==nil ? 1184:552;let ls=lines(r.text,r.role,candidate,width);let rs=r.pair.map{lines($0,r.role,candidate,width)} ?? [];let h=max(CGFloat(max(ls.count,rs.count))*CGFloat(roles[r.role]!["lineHeightSp"]!*4)+32,r.button ? 96:0);heights.append(h);y+=h+16}
 let total=y,viewport:CGFloat=512;var offsets:[CGFloat]=[0];while offsets.last!+viewport<total{offsets.append(min(offsets.last!+viewport-96,total-viewport))}
 for(index,offset) in offsets.enumerated(){let path="\(dir)/\(candidate)-\(mode)-\(index+1).png";let b=image(1280,720){c in
 color("paper").setFill();NSRect(x:0,y:0,width:1280,height:720).fill();c.saveGState();c.clip(to:CGRect(x:0,y:48,width:1280,height:512))
 for(i,r) in rr.enumerated(){let yy=48+positions[i]-offset;let width:CGFloat=r.pair==nil ? 1216:600
 for(j,s) in [r.text,r.pair].compactMap({$0}).enumerated(){let x:CGFloat=32+CGFloat(j)*616;if r.button{color("nav").setFill();NSRect(x:x,y:yy,width:width,height:heights[i]).fill()}
 var ty=yy+16;for(line,lh) in lines(s,r.role,candidate,width-32){c.saveGState();c.translateBy(x:x+16,y:ty+CTFontGetAscent(font(r.role,candidate)));c.scaleBy(x:1,y:-1);
 // Rebuild line colour via foreground-from-context, preserving measured layout.
 c.textMatrix = .identity; c.textPosition = .zero
 if r.button{let range=CTLineGetStringRange(line);let sub=(s as NSString).substring(with:NSRange(location:range.location,length:range.length));let a=NSAttributedString(string:sub,attributes:[.font:font(r.role,candidate),.foregroundColor:color("paper")]);CTLineDraw(CTLineCreateWithAttributedString(a),c)}else{CTLineDraw(line,c)}
 c.restoreGState();ty+=lh}
 }
 };c.restoreGState();color("nav").setFill();NSRect(x:0,y:576,width:1280,height:96).fill()
 let nav=t("market")+"   ·   "+t("map")+"   ·   "+t("cargo");c.saveGState();c.translateBy(x:32,y:640);c.scaleBy(x:1,y:-1);c.textPosition = .zero;CTLineDraw(CTLineCreateWithAttributedString(NSAttributedString(string:nav,attributes:[.font:font("label",candidate),.foregroundColor:color("paper")])),c);c.restoreGState()
 };save(b,path);evidence.append(["path":path,"candidate":candidate,"view":mode,"scrollOffsetPx":offset,"scrollOffsetDp":offset/2,"contentHeightPx":total,"viewportPx":[0,48,1280,512]])
 }
}}
let out:[String:Any] = ["status":"static_trial_not_android_not_approved","profile":"P1-RU-2x-I0","outputPx":[1280,720],"fontScale":2,"density":2,"fonts":fontEvidence,"resolvedRunNames":Array(runs).sorted(),"captures":evidence,"trialGeometry":["paddingDp":16,"gapDp":8,"radiusDp":0,"navigationDp":48,"scrollOverlapPx":96],"limitations":["Geometry is a named render trial, not canonical tokens","Programmatic static scroll offsets; no live scrolling or interaction","C1/C2 require extra detail captures; split master/detail composition","Cards currently use same labelled vertical fields; no production card design approval","No real Android scaling, touch, TalkBack or native-language QA","All prior product/technical open questions preserved"]]
try! JSONSerialization.data(withJSONObject:out,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(dir)/manifest.json"))
print("Rendered \(evidence.count) captures; runs: \(runs)")
for mode in ["list","detail","cards"]{
 let captures=evidence.filter{$0["view"] as! String==mode};let count=captures.count/2
 let sheet=image(640,count*196){c in
 color("paper").setFill();NSRect(x:0,y:0,width:640,height:count*196).fill()
 for e in captures{let path=e["path"] as! String;let index=Int(URL(fileURLWithPath:path).deletingPathExtension().lastPathComponent.split(separator:"-").last!)!-1;let col=e["candidate"] as! String=="F1" ? 0:1;let b=NSBitmapImageRep(data:try! Data(contentsOf:URL(fileURLWithPath:path)))!;c.saveGState();c.translateBy(x:CGFloat(col*320),y:CGFloat(index*196+180));c.scaleBy(x:1,y:-1);c.draw(b.cgImage!,in:CGRect(x:0,y:0,width:320,height:180));c.restoreGState()
 }
 };save(sheet,"\(dir)/compare-\(mode).png")
}
