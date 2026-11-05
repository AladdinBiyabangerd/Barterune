// Static design renderer only; no game or authentication implementation.
import AppKit
import CoreText
import CryptoKit
func read(_ p:String)->[String:Any]{try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:p))) as! [String:Any]}
let spec=read("design/states/D5-cloud-spec.json"), tokens=read("design/states/D5-entry-trial-tokens.json")
let tablet = CommandLine.arguments.contains("--tablet")
var g=tokens["geometry"] as! [String:Int]
if tablet {
 let profiles=read("design/states/D1-canonical-render-matrix.json")["profiles"] as! [[String:Any]]
 let profile=profiles.first{$0["id"] as! String == "P3"}!
 let pixels=profile["outputPx"] as! [Int]
 g["width"]=pixels[0];g["height"]=pixels[1]
 // Reuse phone column widths; center the bounded composition on tablet.
 let origin=(pixels[0] - (tokens["geometry"] as! [String:Int])["width"]!)/2
 g["margin"]! += origin;g["contentX"]! += origin
}
let roles=(read("design/states/D1-canonical-render-matrix.json")["typeTrial"] as! [String:Any])["roles"] as! [String:[String:Int]]
let refs=read("design/states/D6-canonical-token-proposal.json")["referenceColors"] as! [String:[String:String]]
func color(_ k:String)->NSColor{let v=UInt32(refs[k]!["value"]!.dropFirst(),radix:16)!;return NSColor(srgbRed:CGFloat((v>>16)&255)/255,green:CGFloat((v>>8)&255)/255,blue:CGFloat(v&255)/255,alpha:1)}
let manifest=read("design/states/D1-font-binary-manifest.json")["fonts"] as! [[String:Any]]
let f=manifest.first{$0["id"] as! String == "NotoSans"}!
let data=try! Data(contentsOf:URL(fileURLWithPath:f["path"] as! String))
precondition(SHA256.hash(data:data).map{String(format:"%02x",$0)}.joined()==f["sha256"] as! String)
let cg=CGFont(CGDataProvider(data:data as CFData)!)!
// Locale/font-scale stress renderer. Design artifact only, not app UI.
let localization=read("design/states/D5-cloud-localization.json")
let trial=tokens["localizationTrial"] as! [String:Any]
var geo=trial["geometryPx"] as! [String:Int]
if tablet {geo["contentBottom"]=g["height"]!-g["safeBottom"]!;geo["overviewTileHeight"]=400}
let scales=trial["fontScales"] as! [Double],locales=trial["locales"] as! [String]
let languages=localization["languages"] as! [String:[String:Any]]
let options=localization["languageOptions"] as! [[String:String]]
let states=spec["states"] as! [[String:String]]
let out=tablet ? "design/states/D5-cloud-tablet-v1":"design/states/D5-cloud-phone-v1"
try! FileManager.default.createDirectory(atPath:out,withIntermediateDirectories:true)
var scale=1.0, resolved=Set<String>(), missing=0
func font(_ role:String)->CTFont{let r=roles[role]!;let d=CTFontDescriptorCreateWithAttributes([kCTFontVariationAttribute:[NSNumber(value:0x77676874):NSNumber(value:r["weight"]!),NSNumber(value:0x77647468):100]] as CFDictionary);return CTFontCreateWithGraphicsFont(cg,CGFloat(Double(r["sizeSp"]!*2)*scale),nil,d)}
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
struct Block {let text:String;let role:String;let rect:CGRect;let control:Bool;let filled:Bool}
var baseline:[[String:Any]]=[],reports:[[String:Any]]=[],captures=0
let margin=CGFloat(g["margin"]!),gap=CGFloat(g["gap"]!),inset=CGFloat(g["textInset"]!),x=CGFloat(g["contentX"]!),cw=CGFloat(g["contentWidth"]!),minTarget=CGFloat(g["buttonHeight"]!)

for lang in locales {
 let language=languages[lang]!,chrome=language["chrome"] as! [String:String],strings=language["states"] as! [String:[String:String]]
 for fs in scales {
 scale=fs
 let singleColumn=fs >= Double(trial["largeFontSingleColumnFrom"] as! Int)
 let x=singleColumn ? margin:CGFloat(g["contentX"]!),cw=singleColumn ? CGFloat(g["width"]!)-2*margin:CGFloat(g["contentWidth"]!)
 let viewTop=CGFloat(geo[singleColumn ? "largeContentTop":"contentTop"]!),viewHeight=CGFloat(geo["contentBottom"]!)-viewTop
 let profile="\(lang)-\(String(format:"%.1f",fs))x",dir="\(out)/\(profile)"
 try! FileManager.default.createDirectory(atPath:dir,withIntermediateDirectories:true)
 var overviewPaths:[String]=[]
 for state in states {
 let id=state["id"]!,s=strings[id]!
 // Audit old fixed boxes against actual localized text at the requested font scale.
 for (key,role,height,width) in [("title","screenTitle",80,cw),("body","body",144,cw),("note","supporting",72,cw),("primary","label",48,cw-2*inset),("secondary","label",48,cw-2*inset)] {
 if id=="F01-language" && key=="note" {continue}
 let need=shape(s[key]!,role,width).height
 if need>CGFloat(height){baseline.append(["profile":profile,"state":id,"field":key,"neededHeight":need,"fixedHeight":height])}
 }
 var blocks:[Block]=[],y:CGFloat=0
 func add(_ text:String,_ role:String,_ control:Bool=false,_ filled:Bool=false,_ bx:CGFloat?=nil,_ bw:CGFloat?=nil,_ by:CGFloat?=nil)->CGFloat{
 if text.isEmpty{return 0};let width=bw ?? cw;let sh=shape(text,role,width-(control ? 2*inset:0));let height=control ? max(minTarget,sh.height+2*inset):sh.height
 blocks.append(Block(text:text,role:role,rect:CGRect(x:bx ?? x,y:by ?? y,width:width,height:height),control:control,filled:filled))
 if by==nil{y+=height+gap};return height
 }
 if singleColumn {_=add("BARTERUNE","screenTitle")}
 _=add(s["title"]!,"screenTitle");_=add(s["body"]!,"body")
 if let local=s["local"],let cloud=s["cloud"] {
 if fs < 2 {let width=(cw-gap)/2;let row=y
 let lh=add(local,"supporting",false,false,x,width,row)
 let rh=add(cloud,"supporting",false,false,x+width+gap,width,row)
 y+=max(lh,rh)+gap
 }else{_=add(local,"supporting");_=add(cloud,"supporting")}
 }
 if id=="F01-language" {
 if fs==1 {
 let bw=(cw-gap)/2
 for row in 0..<2 {let rowY=y;var rh:CGFloat=0
 for col in 0..<2{let o=options[row*2+col];let label=(o["code"]==lang ? "✓ ":"")+o["label"]!;rh=max(rh,add(label,"label",true,false,x+CGFloat(col)*(bw+gap),bw,rowY))};y+=rh+gap}
 }else{for o in options{_=add((o["code"]==lang ? "✓ ":"")+o["label"]!,"label",true)}}
 }else{_=add(s["note"]!,"supporting")}
 _=add(s["primary"]!,"label",true,true);_=add(s["secondary"]!,"label",true);_=add(chrome["privacy"]!,"supporting",true)
 if singleColumn {_=add(chrome["language"]!,"supporting");_=add(chrome["tagline"]!,"body")}
 let contentHeight=y-gap,maxOffset=max(0,contentHeight-viewHeight)
 var offsets:[CGFloat]=[0];let stride=viewHeight-CGFloat(trial["scrollOverlapPx"] as! Int)
 while offsets.last!<maxOffset{offsets.append(min(maxOffset,offsets.last!+stride))}
 for b in blocks where b.control {offsets.append(min(maxOffset,b.rect.minY))}
 offsets=Array(Set(offsets)).sorted()
 var blockEvidence:[[String:Any]]=[]
 for b in blocks {
 let sh=shape(b.text,b.role,b.rect.width-(b.control ? 2*inset:0))
 // Every line must be fully visible in at least one captured scroll position.
 let ty=b.rect.minY+(b.control ? inset:0)
 let covered=(0..<sh.lines.count).allSatisfy{i in let start=ty+CGFloat(i)*sh.step;return offsets.contains{start >= $0 && start+sh.step <= $0+viewHeight}}
 blockEvidence.append(["text":b.text,"rect":[b.rect.minX,b.rect.minY,b.rect.width,b.rect.height],"textHeight":sh.height,"horizontalFit":sh.maxWidth<=b.rect.width-(b.control ? 2*inset:0)+0.01,"verticalFit":sh.height+(b.control ? 2*inset:0)<=b.rect.height+0.01,"linesCoveredByCaptures":covered,"targetMin48dp": !b.control || b.rect.height>=minTarget,"controlFullyVisible": !b.control || offsets.contains{b.rect.minY >= $0 && b.rect.maxY <= $0+viewHeight}])
 }
 let overlap=blocks.enumerated().contains {i,b in blocks.dropFirst(i+1).contains{b.rect.intersects($0.rect)}}
 var names:[String]=[]
 for (page,offset) in offsets.enumerated(){let name="\(id)-scroll-\(page).png",path="\(dir)/\(name)";names.append(name)
 let b=bitmap(g["width"]!,g["height"]!){
 box(CGRect(x:0,y:0,width:g["width"]!,height:g["height"]!),"paper");if !singleColumn {box(CGRect(x:0,y:0,width:g["identityWidth"]!+g["margin"]!,height:g["height"]!),"nav")
 // Brand, supporting copy and language chrome also scale; no silent text shrink.
 var iy=CGFloat(geo["identityTop"]!)
 for (t,r) in [("BARTERUNE","screenTitle"),(chrome["tagline"]!,"body"),(chrome["language"]!,"supporting")] {paint(t,r,margin,iy,CGFloat(geo["identityWidth"]!),"paper");iy+=shape(t,r,CGFloat(geo["identityWidth"]!)).height+gap}
 if maxOffset>0{paint(offset<maxOffset ? chrome["scroll"]!:chrome["end"]!,"supporting",margin,max(iy,CGFloat(geo["identityCueY"]!)),CGFloat(geo["identityWidth"]!),"paper")}
 } else if maxOffset>0 {paint(offset<maxOffset ? chrome["scroll"]!:chrome["end"]!,"supporting",margin,CGFloat(geo["largeCueY"]!),cw)}
 let ctx=NSGraphicsContext.current!.cgContext;ctx.saveGState();ctx.clip(to:CGRect(x:x,y:viewTop,width:cw,height:viewHeight));ctx.translateBy(x:0,y:viewTop-offset)
 for block in blocks {if block.filled{box(block.rect,"nav")};paint(block.text,block.role,block.rect.minX+(block.control ? inset:0),block.rect.minY+(block.control ? inset:0),block.rect.width-(block.control ? 2*inset:0),block.filled ? "paper":"nav")}
 ctx.restoreGState()
 }
 save(b,path);overviewPaths.append(path);captures+=1
 }
 let identityTexts=[("BARTERUNE","screenTitle"),(chrome["tagline"]!,"body"),(chrome["language"]!,"supporting")]
 var identityEnd=CGFloat(geo["identityTop"]!)
 for (t,r) in identityTexts{identityEnd+=shape(t,r,CGFloat(geo["identityWidth"]!)).height+gap}
 if maxOffset>0{identityEnd=max(identityEnd,CGFloat(geo["identityCueY"]!))+shape(chrome["scroll"]!,"supporting",CGFloat(geo["identityWidth"]!)).height}
 reports.append(["profile":profile,"state":id,"contentHeight":contentHeight,"viewportHeight":viewHeight,"scrollOffsets":offsets,"captures":names,"blocks":blockEvidence,"noBlockOverlap": !overlap,"identitySafe":singleColumn || identityEnd<=CGFloat(g["height"]!-g["safeBottom"]!),"layout":singleColumn ? "single_column_scroll":"split_scroll","allContentReachable":blockEvidence.allSatisfy{$0["linesCoveredByCaptures"] as! Bool}])
 }
 // One contact sheet per profile includes every scroll capture, in state order.
 let cols=geo["overviewColumns"]!,tw=geo["overviewTileWidth"]!,th=geo["overviewTileHeight"]!,rows=(overviewPaths.count+cols-1)/cols
 let overview=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:cols*tw,pixelsHigh:rows*th,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
 NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:overview)
 for (i,path) in overviewPaths.enumerated(){NSImage(contentsOfFile:path)!.draw(in:NSRect(x:(i%cols)*tw,y:rows*th-(i/cols+1)*th,width:tw,height:th))}
 NSGraphicsContext.restoreGraphicsState();save(overview,"\(dir)/overview.png")
 print("\(profile): \(overviewPaths.count) viewport captures")
 }
}
let allFit=reports.allSatisfy{r in (r["noBlockOverlap"] as! Bool) && (r["identitySafe"] as! Bool) && (r["allContentReachable"] as! Bool) && (r["blocks"] as! [[String:Any]]).allSatisfy{($0["horizontalFit"] as! Bool) && ($0["verticalFit"] as! Bool) && ($0["targetMin48dp"] as! Bool) && ($0["controlFullyVisible"] as! Bool)}}
let report:[String:Any]=["status":"static_measured_not_Android_runtime","fontHash":f["sha256"]!,"resolvedFonts":Array(resolved).sorted(),"missingGlyphs":missing,"baselineFixedBoxFailures":baseline,"firstPassIdentityFailures":[],"profiles":locales.count*scales.count,"stateProfiles":reports.count,"captureCount":captures,"allChecksPassed":allFit && missing==0,"states":reports,"limits":["Linear 1/1.3/2 scale simulation; Android nonlinear scaling not measured",tablet ? "P3 synthetic landscape tablet; centered bounded phone columns":"P1 synthetic landscape only","Scroll snapshots show intentional edge clipping; every full text line is visible in at least one capture","AZ/TR/RU/EN; editorial native-speaker review pending","No Firebase, sync or game implementation"]]
try! JSONSerialization.data(withJSONObject:report,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(out)/verification.json"))
print("Baseline failures: \(baseline.count); final allChecksPassed=\(report["allChecksPassed"]!) missingGlyphs=\(missing)")
