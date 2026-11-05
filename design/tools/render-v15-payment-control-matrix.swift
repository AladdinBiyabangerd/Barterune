// Canonical static suite v15: canonical V11/V12 service flow with normalized v13 atlas. No app or game code.
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
var density:CGFloat=2
var scale=1.0, resolved=Set<String>(), missing=0
var fontCache:[String:CTFont]=[:]
func font(_ role:String)->CTFont{let key="\(role)-\(scale)";if let cached=fontCache[key]{return cached};let r=roles[role]!;let d=CTFontDescriptorCreateWithAttributes([kCTFontVariationAttribute:[NSNumber(value:0x77676874):NSNumber(value:r["weight"]!),NSNumber(value:0x77647468):100]] as CFDictionary);let result=CTFontCreateWithGraphicsFont(cg,CGFloat(Double(r["sizeSp"]!*2)*scale),nil,d);fontCache[key]=result;return result}

// Explicit bundled symbol face, never an OS cascade. Size follows the text role.
let symbolManifest=read("design/states/D2-payment-symbol-font.json")
let symbolData=try! Data(contentsOf:URL(fileURLWithPath:symbolManifest["path"] as! String))
precondition(SHA256.hash(data:symbolData).map{String(format:"%02x",$0)}.joined()==symbolManifest["sha256"] as! String)
let symbolCG=CGFont(CGDataProvider(data:symbolData as CFData)!)!
func attributed(_ text:String,_ role:String,_ colorName:String="nav")->NSAttributedString {
 let a=NSMutableAttributedString(string:text,attributes:[.font:font(role),.foregroundColor:color(colorName)])
 let sf=CTFontCreateWithGraphicsFont(symbolCG,CTFontGetSize(font(role)),nil,nil)
 for (i,c) in (text as NSString).description.utf16.enumerated() where c==0x2190 || c==0x2192 {
 var ch=UniChar(c),glyph=CGGlyph(0)
 precondition(CTFontGetGlyphsForCharacters(sf,&ch,&glyph,1) && glyph != 0)
 a.addAttribute(.font,value:sf,range:NSRange(location:i,length:1))
 }
 return a
}

struct Shaped {let lines:[CTLine];let step:CGFloat;let height:CGFloat;let maxWidth:CGFloat}
func shape(_ text:String,_ role:String,_ width:CGFloat,_ colorName:String="nav")->Shaped{
 if text.isEmpty{return Shaped(lines:[],step:0,height:0,maxWidth:0)}
 let a=attributed(text,role,colorName)
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
let resume=CommandLine.arguments.contains("--resume")
var reusePath:String? = nil
func save(_ b:NSBitmapImageRep,_ p:String){if FileManager.default.fileExists(atPath:p){if resume{return};try! FileManager.default.removeItem(atPath:p)};if let source=reusePath,FileManager.default.fileExists(atPath:source){try! FileManager.default.linkItem(atPath:source,toPath:p);return};try! b.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:p))}

// Art integration into a static screen renderer; no gameplay implementation.
let tok=read("design/states/D1-pixel-composition-tokens.json"),geo=read("design/states/D1-pixel-composition-tokens.json")["geometry"] as! [String:Int]
let art=tok["art"] as! [String:Any]
let source=NSImage(contentsOfFile:art["source"] as! String)!.cgImage(forProposedRect:nil,context:nil,hints:nil)!
func g(_ k:String)->CGFloat{CGFloat(geo[k]!)*density/2}
func crop(_ key:String,_ r:CGRect){let a=art[key] as! [Int];let src=["cloth","wood","grain"].contains(key) ? NSImage(contentsOfFile:art["iconSource"] as! String)!.cgImage(forProposedRect:nil,context:nil,hints:nil)!:source;let im=src.cropping(to:CGRect(x:a[0],y:a[1],width:a[2],height:a[3]))!;let c=NSGraphicsContext.current!.cgContext;c.saveGState();c.interpolationQuality = .none;c.translateBy(x:r.minX,y:r.maxY);c.scaleBy(x:1,y:-1);c.draw(im,in:CGRect(origin:.zero,size:r.size));c.restoreGState()}
func frame(_ r:CGRect){box(r,"paper");let e=g("frameEdge");crop("frameTop",CGRect(x:r.minX,y:r.minY,width:r.width,height:e));crop("frameBottom",CGRect(x:r.minX,y:r.maxY-e,width:r.width,height:e));crop("frameLeft",CGRect(x:r.minX,y:r.minY+e,width:e,height:r.height-2*e));crop("frameRight",CGRect(x:r.maxX-e,y:r.minY+e,width:e,height:r.height-2*e))}

let out="design/states/D2-payment-control-matrix-v15"
try! FileManager.default.createDirectory(atPath:out,withIntermediateDirectories:true)
let matrix=read("design/states/D1-canonical-render-matrix.json")
let profiles=matrix["profiles"] as! [[String:Any]]
let localization=read("design/states/D2-payment-localization-v15.json")["languages"] as! [String:[String:String]]
let variants=read("design/states/D2-payment-modes-v15-fixtures.json")["variants"] as! [[String:Any]]
struct Block {let text:String;let role:String;let group:String;let active:Bool;let action:Bool}
struct Item {let block:Block;let rect:CGRect}
func rectData(_ r:CGRect)->[CGFloat]{[r.minX,r.minY,r.width,r.height]}
var results=[[String:Any]]()
let states=["confirm","pending","paid-success","failed","unknown"]
// Rank real fixture labels by unwrapped CoreText advance at the same label role.
scale=1
var selection=[[String:Any]]()
var cases=[(String,Int,String,Double,String,String)]()
for profile in profiles {
 let pid=profile["id"] as! String
 for iid in (pid == "P3" ? [0] : [0,1,2]) {
  for lang in ["AZ","TR","RU","EN"] {
   for fs in [1.0,1.3,2.0] {
    for v in variants {let fixture=v["id"] as! String;let state=states.first{fixture == $0 || fixture.hasPrefix($0+"-")}!;cases.append((pid,iid,lang,fs,state,fixture))}
   }
  }
 }
}
for interaction in ["normal"] {
for (pid,iid,lang,fs,state,fixture) in cases {
 if ["pending","unknown"].contains(state) && interaction.hasPrefix("primary-") {continue}
 autoreleasepool {
 let profile=profiles.first{$0["id"] as! String == pid}!
 density=CGFloat(profile["density"] as! Int);scale=fs*Double(density)/2
 let size=profile["outputPx"] as! [Int],w=CGFloat(size[0]),h=CGFloat(size[1])
 let ins=iid==0 ? profile["safeInsetsDp"] as! [String:Int]:(matrix["insetVariants"] as! [[String:Any]])[iid]["safeInsetsDp"] as! [String:Int]
 let sx=CGFloat(ins["left"]!)*density,sy=CGFloat(ins["top"]!)*density
 let safe=CGRect(x:sx,y:sy,width:w-sx-CGFloat(ins["right"]!)*density,height:h-sy-CGFloat(ins["bottom"]!)*density)
 let pad=g("inset"),gap=g("gap"),target=g("target"),left=safe.minX+g("margin"),top=safe.minY+g("margin"),bottom=safe.maxY-g("margin")
 let width=min(safe.width-2*g("margin"),g("maxTextWidth")),x=left+(safe.width-2*g("margin")-width)/2,cw=(width-gap)/2
 let v=variants.first{$0["id"] as! String == fixture}!,l=localization[lang]!
 func b(_ s:String,_ role:String,_ group:String,_ action:Bool=false,_ active:Bool=false)->Block {Block(text:l[s]!,role:role,group:group,active:active,action:action)}
 let header=[b(v["title"] as! String,"screenTitle","title"),b(v["status"] as! String,"supporting","status")]
 let panes=["left","right"].map{key in (v[key] as! [String]).enumerated().map{b($0.element,$0.offset==0 ? "sectionTitle":"body",key)}}
 let actions=[b(v["primary"] as! String,"label","primary",true,v["enabled"] as! Bool),b("← Geri","label","back",true,true)]
 func bh(_ b:Block,_ width:CGFloat)->CGFloat {max(b.action ? target:0,shape(b.text,b.role,width-2*pad).height+(b.action ? 2*pad:pad))}
 func ph(_ blocks:[Block],_ width:CGFloat)->CGFloat {2*pad+blocks.reduce(CGFloat(0)){$0+shape($1.text,$1.role,width-2*pad).height}}
 let hh=header.reduce(CGFloat(0)){$0+bh($1,width)+gap}
 let ah=actions.map{bh($0,cw)}.max()!
 let paneAvailable=bottom-top-hh-gap-ah
 let paneHeights=panes.map{ph($0,cw)}
 let twoPane=paneHeights.allSatisfy{$0<=paneAvailable}
 var pages=[[Item]]()
 if twoPane {
  var items=[Item](),y=top
  for block in header {let ht=bh(block,width);items.append(Item(block:block,rect:CGRect(x:x,y:y,width:width,height:ht)));y+=ht+gap}
  for (i,blocks) in panes.enumerated(){var yy=y+pad;let xx=x+CGFloat(i)*(cw+gap)
   for block in blocks {let ht=shape(block.text,block.role,cw-2*pad).height;items.append(Item(block:block,rect:CGRect(x:xx,y:yy,width:cw,height:ht)));yy+=ht}
  }
  for (i,block) in actions.enumerated(){items.append(Item(block:block,rect:CGRect(x:x+CGFloat(i)*(cw+gap),y:bottom-ah,width:cw,height:ah)))}
  pages=[items]
 } else {
  var items=[Item](),y=top
  let flow=header+panes.flatMap({$0})+actions
  for (index,block) in flow.enumerated() {
   let ht=bh(block,width)
   // Keep section headings with their first row, and both actions together where possible.
   let keepNext=(block.role == "sectionTitle" || block.group == "primary") && index+1<flow.count
   let required=ht+(keepNext ? gap+bh(flow[index+1],width):0)
   if keepNext && required<=bottom-top && y+required>bottom && !items.isEmpty {pages.append(items);items=[];y=top}
   precondition(ht<=bottom-top,"Single block too tall")
   if y+ht>bottom && !items.isEmpty {pages.append(items);items=[];y=top}
   items.append(Item(block:block,rect:CGRect(x:x,y:y,width:width,height:ht)));y+=ht+gap
  }
  if !items.isEmpty {pages.append(items)}
 }
 let caseID="\(pid)-I\(iid)-\(lang)-\(fs)x-\(fixture)-\(interaction)"
 var captures=[[String:Any]]()
 for (page,items) in pages.enumerated(){
  let path="\(out)/\(caseID)-\(page).png"
  let selectedOnPage=items.contains{$0.block.action && $0.block.active && interaction.hasPrefix($0.block.group+"-")}
  reusePath = interaction != "normal" && !selectedOnPage ? "\(out)/\(pid)-I\(iid)-\(lang)-\(fs)x-\(fixture)-normal-\(page).png" : nil
  var records=[[String:Any]]()
  save(bitmap(size[0],size[1]){
   box(CGRect(x:0,y:0,width:w,height:h),"nav")
   if twoPane {let y=top+hh;for i in 0..<2 {frame(CGRect(x:x+CGFloat(i)*(cw+gap),y:y,width:cw,height:paneAvailable))}}
   for item in items {
    let block=item.block,r=item.rect,isPane=twoPane && ["left","right"].contains(block.group)
    let selected = block.action && block.active && interaction.hasPrefix(block.group+"-")
    let pressed = selected && interaction.hasSuffix("pressed")
    let focused = selected && interaction.contains("focused")
    if !isPane {frame(r);if block.action && block.active {
     let e=g("frameEdge")
     box(r.insetBy(dx:e,dy:e),"nav")
     if pressed {box(r,"nav");box(r.insetBy(dx:e,dy:e),"paper")}
     if focused && !pressed {
      box(r,"paper");box(r.insetBy(dx:e,dy:e),"nav")
     }
    }}
    if focused && pressed {
     let e=g("frameEdge")
     box(r,"paper");box(r.insetBy(dx:e,dy:e),"nav");box(r.insetBy(dx:2*e,dy:2*e),"paper")
    }
    let tx=r.minX+pad,ty=isPane ? r.minY:r.minY+(block.action ? pad:pad/2),tw=r.width-2*pad
    let shaped=shape(block.text,block.role,tw)
    paint(block.text,block.role,tx,ty,tw,block.action && block.active && !pressed ? "paper":"nav")
    let textRect=CGRect(x:tx,y:ty,width:shaped.maxWidth,height:shaped.height)
    records.append(["group":block.group,"text":block.text,"role":block.role,"rect":rectData(r),"textRect":rectData(textRect),"action":block.action,"enabled":block.active,"pressed":pressed,"focused":focused])
   }
  },path)
  captures.append(["path":path,"items":records])
 }
 results.append(["id":caseID,"interaction":interaction,"fixture":v["id"]!,"operationId":v["operationId"]!,"layout":twoPane ? "two-pane":"reflow","cta":twoPane ? "fixed-bottom-pair":"flow-stacked","safeRect":rectData(safe),"density":density,"paneRequiredPx":paneHeights,"paneAvailablePx":paneAvailable,"actionPairHeightPx":ah,"headerWithGapsPx":hh,"pages":captures])
 print("\(caseID): \(twoPane ? "two-pane" : "reflow") \(pages.count) pages; pane required \(paneHeights), available \(paneAvailable)")
}
}
}
// Interaction variants share normal geometry and pixels except for the selected control.
let normalResults=results
for base in normalResults {
 autoreleasepool {
 let baseID=base["id"] as! String
 let fixture=base["fixture"] as! String
 let v=variants.first{$0["id"] as! String == fixture}!
 let pid=baseID.components(separatedBy:"-")[0]
 let profile=profiles.first{$0["id"] as! String == pid}!
 density=CGFloat(profile["density"] as! Int)
 let parts=baseID.components(separatedBy:"-")
 scale=Double(parts[3].dropLast())!*Double(density)/2
 let pad=g("inset"),e=g("frameEdge")
 let size=profile["outputPx"] as! [Int],w=CGFloat(size[0]),h=CGFloat(size[1])
 for interaction in ["primary-pressed","primary-focused","primary-focused-pressed","back-pressed","back-focused","back-focused-pressed"] {
  if interaction.hasPrefix("primary-") && !(v["enabled"] as! Bool){continue}
  var c=base
  let id=String(baseID.dropLast(6))+interaction
  c["id"]=id;c["interaction"]=interaction
  var captures=[[String:Any]]()
  for (page,p) in (base["pages"] as! [[String:Any]]).enumerated() {
   var items=p["items"] as! [[String:Any]]
   let selected=items.indices.filter{items[$0]["action"] as! Bool && items[$0]["enabled"] as! Bool && interaction.hasPrefix((items[$0]["group"] as! String)+"-")}
   for j in selected {items[j]["focused"]=interaction.contains("focused");items[j]["pressed"]=interaction.hasSuffix("pressed")}
   let path="\(out)/\(id)-\(page).png",sourcePath=p["path"] as! String
   if selected.isEmpty {
    if !FileManager.default.fileExists(atPath:path) {try! FileManager.default.linkItem(atPath:sourcePath,toPath:path)}
    else if !resume {try! FileManager.default.removeItem(atPath:path);try! FileManager.default.linkItem(atPath:sourcePath,toPath:path)}
   } else if !resume || !FileManager.default.fileExists(atPath:path) {
    reusePath=nil
    save(bitmap(size[0],size[1]) {
     let im=NSImage(contentsOfFile:sourcePath)!.cgImage(forProposedRect:nil,context:nil,hints:nil)!
     let ctx=NSGraphicsContext.current!.cgContext
     ctx.saveGState();ctx.translateBy(x:0,y:h);ctx.scaleBy(x:1,y:-1);ctx.draw(im,in:CGRect(x:0,y:0,width:w,height:h));ctx.restoreGState()
     for j in selected {
      let a=items[j],rr=a["rect"] as! [CGFloat]
      let r=CGRect(x:rr[0],y:rr[1],width:rr[2],height:rr[3])
      let pressed=a["pressed"] as! Bool,focused=a["focused"] as! Bool
      box(r,focused ? "paper":"nav")
      box(r.insetBy(dx:e,dy:e),pressed && !focused ? "paper":"nav")
      if pressed && focused {box(r.insetBy(dx:2*e,dy:2*e),"paper")}
      paint(a["text"] as! String,"label",r.minX+pad,r.minY+pad,r.width-2*pad,pressed ? "nav":"paper")
     }
    },path)
   }
   captures.append(["path":path,"items":items])
  }
  c["pages"]=captures;results.append(c)
  print(id)
 }
 }
}
let report:[String:Any]=["labelSelection":selection,"caseCount":results.count,"cases":results,"missingGlyphs":missing,"resolvedFonts":resolved.sorted(),"scope":"Full static payment control-state matrix; no device/runtime proof; unchanged source fixtures and tokens. Reflow pages simulate flow, not interactive scrolling."]
try! JSONSerialization.data(withJSONObject:report,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:out+"/measurements.json"))
