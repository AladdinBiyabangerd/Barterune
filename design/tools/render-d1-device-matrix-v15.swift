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
let out="design/states/D1-device-matrix-v15"
let deviceProfiles=read("design/states/D1-canonical-render-matrix.json")["profiles"] as! [[String:Any]]
try! FileManager.default.createDirectory(atPath:out,withIntermediateDirectories:true)
struct Row {var text:String;var role="body";var action=false;var pair:String?=nil;var icon:String?=nil;var pairAction:Bool?=nil;var columns:Int=1}
var reports:[[String:Any]]=[]
for lang in ["AZ","TR","RU","EN"] {let l=langs[lang]!
 func t(_ k:String,_ v:[String:String]=[:])->String{var s=l[k]!;for (k,v) in v{s=s.replacingOccurrences(of:"{\(k)}",with:v)};return s}
 var sections:[(String,[Row])]=[("services",["workshop","creditor","hire"].map{Row(text:t($0),role:"label",action:true)})]
 for mode in ["list","cards"] {var rr=[Row(text:t("goods")+" · "+t(mode),role:"sectionTitle")];for good in goods{let id=good["id"] as! String;rr += [Row(text:t(id)+(id=="cloth" ? " · ✓ "+t("selected"):""),role:"sectionTitle",icon:["cloth","wood","grain"].contains(id) ? id:nil),Row(text:t("buy")+" \(good["buyUnit"]!) · "+t("sell")+" \(good["sellUnitUndamaged"]!)",role:"numeric"),Row(text:t("stock")+" \(good["stock"]!) · "+t("owned")+" \(id=="cloth" ? 8:0) · "+t("unitLoad")+" \(good["unitLoad"]!)"),Row(text:t("openDetails",["good":t(id)]),role:"label",action:true)]};if mode == "cards" {rr=[Row(text:t("goods")+" · "+t(mode),role:"sectionTitle")];for good in goods {let id=good["id"] as! String;rr.append(Row(text:t(id)+(id=="cloth" ? " · ✓":"")+"\n"+t("buy")+" \(good["buyUnit"]!) · "+t("sell")+" \(good["sellUnitUndamaged"]!)\n"+t("stock")+" \(good["stock"]!) · "+t("owned")+" \(id=="cloth" ? 8:0)\n"+t("unitLoad")+" \(good["unitLoad"]!)\n"+t("openDetails",["good":t(id)]),role:"body",action:true,columns:2))}};sections.append((mode,rr))}
 sections += [("good",[Row(text:t("cloth"),role:"screenTitle",icon:"cloth"),Row(text:t("buyUnit")+" 35 · "+t("sellUnit")+" 28"),Row(text:t("stock")+" 30 · "+t("owned")+" 8 · "+t("unitLoad")+" 2"),Row(text:t("batches"),role:"label",action:true),Row(text:t("quantity")+" 2",role:"label",action:true)]),
 ("batches",[Row(text:t("batches"),role:"sectionTitle"),Row(text:"✓ "+t("healthy")+" · "+t("selected"),role:"label"),Row(text:t("quality",["quality":"100"])+" · "+t("batchCount",["count":"5"])),Row(text:t("averageCost")+" 24 · "+t("margin")+" +4"),Row(text:t("damaged")+" · "+t("unselected"),role:"label"),Row(text:t("quality",["quality":"60"])+" · "+t("batchCount",["count":"3"])),Row(text:t("averageCost")+" 20 · "+t("sellUnit")+" —"),Row(text:t("chooseBatch",["batch":t("damaged")]),role:"label",action:true),Row(text:t("marginNote"),role:"supporting")])]
 for (id,gold,load,total) in [("buyPreview",430,20,70),("sellPreview",556,12,56)] {sections.append((id,[Row(text:t(id),role:"sectionTitle"),Row(text:t("cloth")+" · "+t("quantity")+" 2",icon:"cloth"),Row(text:"✓ "+t("healthy")+" · "+t("batchCount",["count":"5"])),Row(text:t(id=="buyPreview" ? "buyTotal":"sellTotal",["total":"\(total)"]),role:"numeric"),Row(text:t("gold")+" 500 → \(gold) · "+t("load")+" 16/40 → \(load)/40",role:"numeric"),Row(text:t("buyMax",["max":"12"]),role:"label",action:true),Row(text:t("sellMax",["max":"5"]),role:"label",action:true),Row(text:t("maxNote"),role:"supporting"),Row(text:t("buyAmount",["total":"70"]),role:"label",action:true,pair:t("sellAmount",["total":"56"]))]))}
 for (id,keys) in [("quantity",["enterQuantity","minimum","wholeNumbers","digitCap","editing"]),("invalid-empty",["enterQuantity","minimum"]),("invalid-zero",["enterQuantity","minimum"]),("invalid-digits",["enterQuantity","digitCap"]),("invalid-negative",["enterQuantity","minimum"]),("invalid-decimal",["enterQuantity","wholeNumbers"]),("invalid-seven-digits",["enterQuantity","digitCap"])] {var r=keys.map{Row(text:t($0),role:"label")};r.append(Row(text:["quantity":"2","invalid-zero":"0","invalid-negative":"−2","invalid-decimal":"2.5","invalid-seven-digits":"1234567","invalid-digits":"1234567"][id] ?? "—",role:"numeric"));for digits in ["1","2","3","4","5","6","7","8","9","←","0","✓"]{r.append(Row(text:digits,role:"numeric",action:digits != "✓" || id=="quantity",columns:3))};r += [Row(text:t("backspace")+" · ←",role:"supporting"),Row(text:t("apply")+" · ✓",role:"supporting"),Row(text:t("cancel"),role:"label",action:true)];sections.append((id,r))}
 for stress in fixture["stressFixtures"] as! [[String:Any]] {let id=stress["id"] as! String;let ex=stress["expected"] as? [String:Any] ?? stress;let keys=(ex["reasonKeys"] ?? stress["messageKeys"]) as? [String] ?? [];var r=[Row(text:t("cloth")+" · "+t("quantity")+" 2",role:"sectionTitle",icon:"cloth")];r += keys.map {Row(text:t($0,["deficit":"50"]),role:"label")};let buy=ex["buyEnabled"] as? Bool ?? false,sell=ex["sellEnabled"] as? Bool ?? false;r += [Row(text:t("buyAmount",["total":buy ? "70":"—"]),role:"label",action:buy,pair:t("sellAmount",["total":sell ? "56":"—"]),pairAction:sell)];if id=="O03"{r.append(Row(text:t("checkResult"),role:"label",action:true))};if id=="O05"{r.append(Row(text:t("refreshMarket"),role:"label",action:true))};sections.append((id,r))}
 for (id,key,gold,load) in [("purchase-success","purchaseSaved",430,20),("sale-success","saleSaved",556,12),("save-failed","saveFailed",500,16),("price-changed","priceChanged",500,16)] {sections.append((id,[Row(text:t(key),role:"sectionTitle"),Row(text:t("gold")+" \(gold) · "+t("load")+" \(load)/40",role:"numeric"),Row(text:t("quantityKept")),Row(text:t(id=="price-changed" ? "refreshMarket":"backToMarket"),role:"label",action:true)]))}
 sections += [
 ("no-owned",[Row(text:t("cloth"),role:"screenTitle",icon:"cloth"),Row(text:t("owned")+" 0"),Row(text:t("noOwned"),role:"label"),Row(text:t("buyAmount",["total":"70"]),role:"label",action:true,pair:t("sellAmount",["total":"—"]),pairAction:false)]),
 ("price-confirmation",[Row(text:t("priceChanged"),role:"sectionTitle"),Row(text:t("cloth")+" · "+t("quantity")+" 2",icon:"cloth"),Row(text:t("buyUnit")+" 35 → 40"),Row(text:t("buyTotal",["total":"70 → 80"]),role:"numeric"),Row(text:t("gold")+" 500 → 420 · "+t("load")+" 16/40 → 20/40"),Row(text:t("acceptNewPrice"),role:"label",action:true),Row(text:t("cancel"),role:"label",action:true)]),
 ("new-purchase-batch",[Row(text:t("purchaseSaved"),role:"sectionTitle"),Row(text:t("cloth"),role:"label",icon:"cloth"),Row(text:t("batchCount",["count":"2"])+" · "+t("quality",["quality":"100"])),Row(text:t("averageCost")+" 35"),Row(text:t("owned")+" 8 → 10 · "+t("load")+" 16 → 20"),Row(text:t("batches"),role:"label",action:true)])]
 sections.append(("equipment-final",[Row(text:t("workshop"),role:"screenTitle"),Row(text:t("currentTrip"),role:"supporting")]+["bag","cart","protectiveGear"].flatMap{key in [Row(text:t(key),role:"sectionTitle"),Row(text:t("finalLevel"),role:"label"),Row(text:t("currentEffect"),role:"body")]}+[Row(text:t("close"),role:"label",action:true)]))
 for fs in [1.0,1.3,2.0] {scale=fs
 for profile in deviceProfiles where ["P2","P3"].contains(profile["id"] as! String) {
 let device=profile["id"] as! String, px=profile["outputPx"] as! [Int]
 let factor=CGFloat(profile["density"] as! Int)/2
 let safe=profile["safeInsetsDp"] as! [String:Int]
 let safeLeft=CGFloat(safe["left"]!*2), safeRight=CGFloat(safe["right"]!*2)
 let w=CGFloat(px[0])/factor-safeLeft-safeRight,h=CGFloat(px[1])/factor
 let margin=g("margin"),gap=g("gap"),inset=g("inset"),target=g("target"),safeTop=g("safeTop"),safeBottom=g("safeBottom")
 let hud=t("day",["day":"4","totalDays":"20"])+" · "+t("gold")+" 500 · "+t("load")+" 16/40"
 let hudH=shape(hud,"numeric",w-2*margin-2*inset).height+inset
 let navH:CGFloat=fs>=2 ? 0:max(target,shape(t("market"),"label",(w-4*margin)/3-2*inset).height+inset)
 let artH:CGFloat=fs>=2 ? 0:g("artHeight");let navY=h-safeBottom-navH,artY=safeTop+hudH+gap,top=artY+artH+(artH>0 ? gap:0)
 let side=false,ax=margin,aw=side ? g("artWidth"):0
 let cw=min(g("maxTextWidth"),w-2*margin),cx=(w-cw)/2,ch=navY-gap-top
 precondition(ch>target)
 for (id,rows) in sections {autoreleasepool {let focusContext = (id == "quantity" || id.hasPrefix("invalid-")) ? t("quantity")+": "+(["quantity":"2","invalid-zero":"0","invalid-negative":"−2","invalid-decimal":"2.5","invalid-seven-digits":"1234567","invalid-digits":"1234567"][id] ?? "—")+" · "+t(id == "invalid-negative" || id == "invalid-zero" || id == "invalid-empty" ? "minimum" : id == "invalid-decimal" ? "wholeNumbers" : id.hasPrefix("invalid-") ? "digitCap":"editing") : "";let contextH = focusContext.isEmpty ? 0:shape(focusContext,"supporting",cw-2*inset).height+inset+gap;let isKeypad=id=="quantity" || id.hasPrefix("invalid-") || id=="cards";let top=isKeypad ? safeTop+hudH+gap:top;let ch=isKeypad ? h-safeBottom-gap-top-contextH:ch;let values:[String:(Int,Int)]=["L06":(20,16),"L07":(500,40),"L08":(20,40),"O05":(556,12),"T05":(640,6),"new-purchase-batch":(430,20),"purchase-success":(430,20),"sale-success":(556,12)];let hv=values[id] ?? (500,16);let renderHud=t("day",["day":"4","totalDays":"20"])+" · "+t("gold")+" \(hv.0) · "+t("load")+" \(hv.1)/40";let name="\(device)-\(lang)-\(fs)x-\(id)",dir="\(out)/\(name)";try! FileManager.default.createDirectory(atPath:dir,withIntermediateDirectories:true)
 var blocks:[(Row,CGRect)]=[],yy:CGFloat=inset
 let contextRows=[Row(text:"← "+t("backToMarket"),role:"label",action:true)] + rows
 let adaptedRows=contextRows.flatMap{row -> [Row] in
 var r=row
 if id=="cards" && fs>=1.3 && r.columns==2 {
  r.columns=1;r.action=false
  let lines=r.text.components(separatedBy:"\n")
  r.text=lines.dropLast().joined(separator:"\n")
  return [r,Row(text:lines.last!,role:"label",action:true)]
 }
 return [r]
 }
 let visibleRows=adaptedRows+(fs>=2 ? ["market","map","cargo"].map{Row(text:t($0),role:"label",action:true)}:[])
 var index=0
 while index<visibleRows.count {let count=visibleRows[index].columns;let group=Array(visibleRows[index..<min(index+count,visibleRows.count)]);let ww=(cw-2*inset-CGFloat(count-1)*gap)/CGFloat(count)
 let hh=group.map{row -> CGFloat in let tw=row.pair==nil ? ww-2*inset-(row.icon==nil ? 0:target):((ww-gap)/2-2*inset);return max(row.action || row.pair != nil ? target:0,max(shape(row.text,row.role,tw).height,row.pair.map{shape($0,row.role,tw).height} ?? 0)+inset)}.max()!
 for (column,row) in group.enumerated(){blocks.append((row,CGRect(x:cx+inset+CGFloat(column)*(ww+gap),y:yy,width:ww,height:hh)))};yy+=hh+gap;index+=group.count
 }
 let vh=ch-2*inset,maxOff=max(0,yy-vh),step=max(target,vh-target);var offsets:[CGFloat]=[0];while offsets.last!<maxOff{offsets.append(min(maxOff,offsets.last!+step))}
 for (_,r) in blocks where r.height<=vh {if !offsets.contains(where:{r.minY >= $0 && r.maxY <= $0+vh}){offsets.append(min(maxOff,max(0,r.minY)))}}
 if let first=blocks.first(where:{$0.0.columns==3}),let last=blocks.last(where:{$0.0.columns==3}),last.1.maxY-first.1.minY<=vh {offsets.append(first.1.minY)}
 offsets=Array(Set(offsets)).sorted();var paths:[String]=[]
 for (page,off) in offsets.enumerated(){let path="\(dir)/scroll-\(page).png";paths.append(path)
 if !CommandLine.arguments.contains("--reuse-unchanged") || !FileManager.default.fileExists(atPath:path) || (id=="cards" && fs>=1.3) {save(bitmap(px[0],px[1]){
 let nativeContext=NSGraphicsContext.current!.cgContext
 box(CGRect(x:0,y:0,width:CGFloat(px[0]),height:CGFloat(px[1])),"nav")
 nativeContext.scaleBy(x:factor,y:factor);nativeContext.translateBy(x:safeLeft,y:0)
 box(CGRect(x:0,y:0,width:w,height:h),"nav")
 box(CGRect(x:margin,y:safeTop,width:w-2*margin,height:hudH),"paper");paint(renderHud,"numeric",margin+inset,safeTop+inset/2,w-2*margin-2*inset)
 if side {let ar=CGRect(x:ax,y:top,width:aw,height:ch);frame(ar);crop("panorama",CGRect(x:ax+g("frameEdge"),y:top+g("frameEdge"),width:aw-2*g("frameEdge"),height:g("artHeight")))
 paint(t("city"),"sectionTitle",ax+inset,top+g("artHeight")+gap,aw-2*inset)
 var sy=top+g("artHeight")+gap+shape(t("city"),"sectionTitle",aw-2*inset).height+gap
 for k in ["market"] {let hh=max(target,shape(t(k),"label",aw-2*inset).height+inset);if sy+hh<=ar.maxY-inset {paint(t(k),"label",ax+inset,sy,aw-2*inset)};sy+=hh+gap}
 }
 if !focusContext.isEmpty {let cy=h-safeBottom-contextH+gap;box(CGRect(x:cx,y:cy,width:cw,height:contextH-gap),"paper");paint(focusContext,"supporting",cx+inset,cy+inset/2,cw-2*inset)}
 if artH>0 && !isKeypad {crop("panorama",CGRect(x:margin,y:artY,width:w-2*margin,height:artH))};frame(CGRect(x:cx,y:top,width:cw,height:ch));let c=NSGraphicsContext.current!.cgContext;c.saveGState();c.clip(to:CGRect(x:cx+inset,y:top+inset,width:cw-2*inset,height:vh));c.translateBy(x:0,y:top+inset-off)
 for (row,r) in blocks {let pair=row.pair != nil,bw=pair ? (r.width-gap)/2:r.width
 let rr=CGRect(x:r.minX,y:r.minY,width:bw,height:r.height)
 if row.action {box(rr,"nav")};let ix=row.icon==nil ? 0:target
 if let icon=row.icon {crop(icon,CGRect(x:r.minX,y:r.minY,width:target,height:target/1.5))}
 paint(row.text,row.role,r.minX+inset+ix,r.minY+inset/2,bw-2*inset-ix,row.action ? "paper":"nav")
 if let other=row.pair {let pr=CGRect(x:r.minX+bw+gap,y:r.minY,width:bw,height:r.height);if row.pairAction ?? row.action{box(pr,"nav")};paint(other,row.role,pr.minX+inset,pr.minY+inset/2,bw-2*inset,(row.pairAction ?? row.action) ? "paper":"nav")}
 };c.restoreGState()
 let nw=(w-4*margin)/3
 for (i,key) in (fs>=2 || isKeypad ? []:["market","map","cargo"]).enumerated(){let nr=CGRect(x:margin+CGFloat(i)*(nw+margin),y:navY,width:nw,height:navH);frame(nr);paint((i==0 ? "✓ ":"")+t(key),"label",nr.minX+inset,nr.minY+inset/2,nw-2*inset)}
 },path)}
 }
 let rowChecks=blocks.map{row,r -> [String:Any] in let tw=(row.pair==nil ? r.width-2*inset-(row.icon==nil ? 0:target):(r.width-gap)/2-2*inset);let sh=shape(row.text,row.role,tw);let linesVisible=(0..<sh.lines.count).allSatisfy{i in let y=r.minY+inset/2+CGFloat(i)*sh.step;return offsets.contains{y >= $0 && y+sh.step <= $0+vh}};let isControl=row.action || (row.pairAction ?? false);let controlVisible = !isControl || offsets.contains{r.minY >= $0 && r.maxY <= $0+vh};return ["text":row.text,"linesVisible":linesVisible,"controlVisible":controlVisible,"minTarget": !isControl || (r.height>=target && (row.pair==nil ? r.width:(r.width-gap)/2)>=target)]};let fit=blocks.allSatisfy{row,r in let tw=(row.pair==nil ? r.width-2*inset-(row.icon==nil ? 0:target):(r.width-gap)/2-2*inset);return shape(row.text,row.role,tw).maxWidth<=tw+0.01}
 reports.append(["id":name,"captures":paths,"horizontalFit":fit,"checks":rowChecks,"allChecksPassed":fit && rowChecks.allSatisfy{($0["linesVisible"] as! Bool) && ($0["controlVisible"] as! Bool) && ($0["minTarget"] as! Bool)},"contentHeight":yy,"viewportHeight":vh,"offsets":offsets,"rows":blocks.count,"minimumTargetPx":target,"scope":"Static art composition; scroll crops intentional. HUD uses each fixture’s saved current state; previews never replace it."])
 }
 }
 }
}
}
let result:[String:Any]=["matrixScope":"D1 P2/P3: all 30 source states × AZ/TR/RU/EN × 1.0/1.3/2.0; native profile dimensions and base safe insets","profiles":reports,"missingGlyphs":missing,"allChecksPassed":missing==0 && reports.allSatisfy{$0["allChecksPassed"] as! Bool},"allHorizontalFit":reports.allSatisfy{$0["horizontalFit"] as! Bool},"artSource":art["source"]!,"gameCodeChanged":false,"limits":["P2/P3 synthetic linear scaling only; no Android touch/TalkBack or nonlinear font scaling", "Three existing goods icon crops only; seven dedicated icons pending", "Two-column cards and three-column keypad rendered; compact whole-panel and responsive master/detail refinement pending", "Static enablement labels only; interaction/semantics pending", "This matrix covers the 30 inherited D1 state identities only; it makes no D2–D6 coverage claim"]]
try! JSONSerialization.data(withJSONObject:result,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(out)/verification.json"))
print("profiles=\(reports.count) missing=\(missing)")
