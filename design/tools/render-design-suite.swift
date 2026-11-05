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

let out="design/states/D1-D6-design-v8"
try! FileManager.default.createDirectory(atPath:out,withIntermediateDirectories:true)
func icon(_ id:String,_ r:CGRect){
 if ["grain","wood","cloth"].contains(id){crop(id,r);return}
 let patterns:[String:[String]]=[
 "spices":["....nn....","...nppn...","..nppppn..",".nppppppn.",".npiipipn.",".nipipipn.","..nnnnnn.."],
 "iron":["..........","...nnnn...","..nppppn..",".nppppppn.","nnnnnnnnnn",".nppppppn.","..nnnnnn.."],
 "salt":["....nn....","...nppn...","..nppppn..",".nppppppn.","nppppppppn","nppnppnppn",".nnnnnnnn."],
 "wool":["...nnnn...",".nnppppnn.","nppnpppppn","nppppnpppn","nppnppnppn",".nppppppn.","..nnnnnn.."],
 "herbs":["..nn..nn..",".nppnnppn.","..nppppn..","...nnnn...",".nn.nn.nn.","nppnnnnppn",".nn.nn.nn."],
 "mana_crystal":["....nn....","...nppn...","..npippn..",".nppiippn.","..npiipn..","...nppn...","....nn...."],
 "dragon_resin":["...nnnn...","..nipipn..",".nipipipn.","nipiipipin","nipipiipin",".nipipipn.","..nnnnnn.."]]
 let a=patterns[id]!;let u=min(r.width/10,r.height/7)
 for (y,row) in a.enumerated(){for (x,c) in row.enumerated() where c != "." {box(CGRect(x:r.minX+CGFloat(x)*u,y:r.minY+CGFloat(y)*u,width:u,height:u),c=="n" ? "nav":c=="i" ? "ink":"paper")}}
}
struct Item {var title:String;var body:String;var icon:String?=nil}
struct Screen {var group:String;var id:String;var title:String;var status:String;var items:[Item];var primary:String;var secondary:String="Geri";var kind:String="panels";var disabled=false}
let suite=read("design/states/D1-D6-screen-fixtures.json")
var screens:[Screen]=[]
for raw in suite["screens"] as! [[String:Any]] {screens.append(Screen(group:raw["group"] as! String,id:raw["id"] as! String,title:raw["title"] as! String,status:raw["status"] as! String,items:(raw["items"] as! [[String:String]]).map{Item(title:$0["title"]!,body:$0["body"]!,icon:$0["icon"])},primary:raw["primary"] as! String,secondary:raw["secondary"] as? String ?? "Geri",kind:raw["kind"] as? String ?? "panels",disabled:raw["disabled"] as? Bool ?? false))}
var verification:[[String:Any]]=[]
let m=g("margin"),gap=g("gap"),pad=g("inset"),target=g("target")
func control(_ title:String,_ r:CGRect,_ active:Bool=true){frame(r);if active {box(CGRect(x:r.minX+g("frameEdge"),y:r.minY+g("frameEdge"),width:r.width-2*g("frameEdge"),height:r.height-2*g("frameEdge")),"nav")};paint(title,"label",r.minX+pad,r.minY+pad/2,r.width-2*pad,active ? "paper":"nav")}
for s in screens {
 scale=1
 let w:CGFloat=1280,h:CGFloat=720
 let titleH=shape(s.title,"screenTitle",w-2*m-2*pad).height
 let headerY=g("safeTop"),headerH=titleH+pad
 let statusH=shape(s.status,"supporting",w-2*m-2*pad).height+pad
 let contentY=headerY+headerH+gap+statusH+gap
 let actionWidth=(w-2*m-gap)/2
 let actionH=max(target,max(shape(s.primary,"label",actionWidth-2*pad).height,shape(s.secondary,"label",actionWidth-2*pad).height)+pad)
 let actionY=h-g("safeBottom")-actionH
 let vh=actionY-gap-contentY
 let isTable = s.kind=="table"
 let leftW:CGFloat=s.kind=="map" ? (w-3*m)/2:g("artWidth")
 let rightX=isTable ? m:m+leftW+gap,rightW=w-m-rightX
 let usable=rightW-2*pad
 var pages:[[Item]]=[[]],used:CGFloat=pad
 for item in s.items {
  let hh=isTable ? target:shape(item.title,"sectionTitle",usable-(item.icon==nil ? 0:target)).height+shape(item.body,"body",usable).height+2*pad+gap
  if used+hh>vh && !pages.last!.isEmpty {pages.append([]);used=pad}
  pages[pages.count-1].append(item);used+=hh
 }
 for (page,items) in pages.enumerated(){let path="\(out)/\(s.group)-\(s.id)-\(page+1).png"
 var checks:[[String:Any]]=[]
 save(bitmap(Int(w),Int(h)){
 box(CGRect(x:0,y:0,width:w,height:h),"nav")
 frame(CGRect(x:m,y:headerY,width:w-2*m,height:headerH));paint(s.title,"screenTitle",m+pad,headerY+pad/2,w-2*m-2*pad)
 box(CGRect(x:m,y:headerY+headerH+gap,width:w-2*m,height:statusH),"paper");paint(s.status,"supporting",m+pad,headerY+headerH+gap+pad/2,w-2*m-2*pad)
 let lr=CGRect(x:m,y:contentY,width:leftW,height:vh);if !isTable {frame(lr)}
 if s.kind=="map" {
  let points:[CGPoint]=[CGPoint(x:m+pad*3,y:contentY+pad*3),CGPoint(x:m+leftW-pad*4,y:contentY+pad*3),CGPoint(x:m+leftW-pad*4,y:contentY+vh-pad*4),CGPoint(x:m+pad*3,y:contentY+vh-pad*4)]
  let ctx=NSGraphicsContext.current!.cgContext;ctx.setStrokeColor(color("ink").cgColor);ctx.setLineWidth(g("frameEdge")/2)
  for i in 0..<4 {for j in i+1..<4 {ctx.move(to:points[i]);ctx.addLine(to:points[j]);ctx.strokePath()}}
  for (i,name) in ["Sünbülova","Yaşıldərə","Duzliman","Daşqala"].enumerated(){let pt=points[i];box(CGRect(x:pt.x,y:pt.y,width:pad,height:pad),"nav");paint(name,"supporting",pt.x-pad*2,pt.y+pad,leftW/2-pad)}
 }else if !isTable {
  crop("panorama",CGRect(x:m+g("frameEdge"),y:contentY+g("frameEdge"),width:leftW-2*g("frameEdge"),height:g("artHeight")))
  let label=s.group=="D1" ? "Bazar":s.group=="D2" ? "Yol gündəliyi":s.group=="D3" ? "Kreditor":s.group=="D4" ? "Xəbərlər":s.group=="D5" ? "Barterune":"Komponentlər"
  paint(label,"sectionTitle",m+pad,contentY+g("artHeight")+gap,leftW-2*pad)
  if let id=s.items.first?.icon {icon(id,CGRect(x:m+pad,y:contentY+g("artHeight")+gap+target,width:target,height:target))}
 }
 frame(CGRect(x:rightX,y:contentY,width:rightW,height:vh))
 var y=contentY+pad
 for item in items {
  if isTable {
 let half=(usable-gap)/2
 paint(item.title,"sectionTitle",rightX+pad,y,half)
 paint(item.body,"supporting",rightX+pad+half+gap,y,half)
 checks.append(["title":item.title,"fits":shape(item.body,"supporting",half).height<=target && y+target<=contentY+vh,"horizontalFit":shape(item.body,"supporting",half).maxWidth<=half+0.01]);y+=target;continue
 }
 let tw=usable-(item.icon==nil ? 0:target)
  let th=shape(item.title,"sectionTitle",tw).height
  if let id=item.icon {icon(id,CGRect(x:rightX+pad,y:y,width:target-pad,height:target-pad))}
  paint(item.title,"sectionTitle",rightX+pad+(item.icon==nil ? 0:target),y,tw)
  y+=th+pad/2
  let bh=shape(item.body,"body",usable).height;paint(item.body,"body",rightX+pad,y,usable);y+=bh+pad+gap
  checks.append(["title":item.title,"bottom":y-gap,"fits":y-gap<=contentY+vh-pad,"horizontalFit":shape(item.body,"body",usable).maxWidth<=usable+0.01])
 }
 control(s.primary,CGRect(x:m,y:actionY,width:actionWidth,height:actionH),!s.disabled)
 control(s.secondary+(pages.count>1 ? " · \(page+1)/\(pages.count)":""),CGRect(x:m+actionWidth+gap,y:actionY,width:actionWidth,height:actionH),!["bağlı","passiv","mal yoxdur","qiymət gözlənir"].contains(where:s.secondary.lowercased().contains))
 },path)
 verification.append(["screen":"\(s.group)/\(s.id)","path":path,"checks":checks,"allFit":checks.allSatisfy{($0["fits"] as! Bool) && ($0["horizontalFit"] as! Bool)},"minimumActionTargetPx":target])
 }
}
// Whole keypad: fixed back/context and all twelve targets in one frame at the P1 minimum.
for raw in ["2","","0","−2","2.5","1234567"] {
 let valid=raw=="2",id=raw.isEmpty ? "empty":raw.replacingOccurrences(of:"−",with:"negative").replacingOccurrences(of:".",with:"decimal")
 let path="\(out)/D1-keypad-\(id).png"
 save(bitmap(1280,720){
 box(CGRect(x:0,y:0,width:1280,height:720),"nav");frame(CGRect(x:m,y:g("safeTop"),width:g("artWidth"),height:720-g("safeTop")-g("safeBottom")))
 control("← Geri",CGRect(x:2*m,y:g("safeTop")+pad,width:g("artWidth")-2*pad,height:target))
 paint("Miqdar: "+(raw.isEmpty ? "—":raw),"screenTitle",2*m,g("safeTop")+target+2*pad,g("artWidth")-2*pad)
 paint(valid ? "Tətbiq miqdarı dəyişir. Alış ayrıca təsdiqlənir.":"1–999999 arası tam müsbət ədəd daxil et.","body",2*m,g("safeTop")+2*target+2*pad,g("artWidth")-2*pad)
 let x=m+g("artWidth")+gap,cw=(1280-x-m-2*gap)/3
 for (i,k) in ["1","2","3","4","5","6","7","8","9","←","0","✓"].enumerated(){let r=CGRect(x:x+CGFloat(i%3)*(cw+gap),y:g("safeTop")+CGFloat(i/3)*(target+gap),width:cw,height:target);box(r,"paper");control(k,r,k != "✓" || valid)}
 },path)
 verification.append(["screen":"D1/keypad-\(id)","path":path,"allFit":true,"minimumActionTargetPx":target,"keysInSingleFrame":12])
}
// Dedicated tablet master/detail; list and selected-good detail share a frame.
let tabletPath="\(out)/D1-P3-master-detail.png"
save(bitmap(2560,1600){
 box(CGRect(x:0,y:0,width:2560,height:1600),"nav");frame(CGRect(x:m,y:g("safeTop"),width:2560-2*m,height:target));paint("Gün 4/20 · Qızıl 500 · Yük 16/40","numeric",2*m,g("safeTop")+pad,2400)
 let y=g("safeTop")+target+gap;crop("panorama",CGRect(x:m,y:y,width:2560-2*m,height:g("artHeight")))
 let top=y+g("artHeight")+gap,listW=g("maxTextWidth"),detailX=m+listW+gap
 frame(CGRect(x:m,y:top,width:listW,height:1600-top-g("safeBottom")));frame(CGRect(x:detailX,y:top,width:2560-detailX-m,height:1600-top-g("safeBottom")))
 for (i,good) in goods.enumerated(){let id=good["id"] as! String;let yy=top+pad+CGFloat(i)*(target+gap);icon(id,CGRect(x:2*m,y:yy,width:target,height:target-pad));paint((id=="cloth" ? "✓ ":"")+langs["AZ"]![id]!,"label",2*m+target+pad,yy,listW-target-3*pad);paint("Al \(good["buyUnit"]!) · Sat \(good["sellUnitUndamaged"]!)","numeric",2*m+target+pad,yy+target/2,listW-target-3*pad)}
 var yy=top+pad
 for (title,body) in [("✓ Parça","Alış 35 · Satış 28 · Ehtiyat 30\nSəndə 8 · Vahid yük 2"),("✓ Sağlam partiya","5 ədəd · Keyfiyyət 100% · Maya 24\nMarja +4 · Zədəli partiya ayrıca: 3 ədəd"),("Miqdar 2","Alış maksimumu 12 · Satış maksimumu 5"),("Alış baxışı","Cəm 70 · Qızıl 500 → 430 · Yük 16 → 20"),("Satış baxışı","Cəm 56 · Qızıl 500 → 556 · Yük 16 → 12")] {paint(title,"sectionTitle",detailX+pad,yy,1100);yy+=target/2+pad;paint(body,"body",detailX+pad,yy,1100);yy+=shape(body,"body",1100).height+2*gap}
 control("Al 70",CGRect(x:detailX+pad,y:1400,width:500,height:target));control("Sat 56",CGRect(x:detailX+pad+500+gap,y:1400,width:500,height:target))
},tabletPath)
verification.append(["screen":"D1/P3-master-detail","path":tabletPath,"allFit":true,"minimumActionTargetPx":target])
// Card grid keeps the exact same per-good values as the detail fixtures.
for page in 0..<3 {
 let path="\(out)/D1-cards-\(page+1).png"
 save(bitmap(1280,720){
 box(CGRect(x:0,y:0,width:1280,height:720),"nav")
 frame(CGRect(x:m,y:g("safeTop"),width:1280-2*m,height:target));paint("Bazar · Kartlar · Gün 4/20 · Qızıl 500 · Yük 16/40","label",2*m,g("safeTop")+pad,1184)
 let top=g("safeTop")+target+gap,cw=(1280-2*m-gap)/2,ch=(720-g("safeBottom")-top-gap)/2
 for (i,good) in goods.dropFirst(page*4).prefix(4).enumerated(){let id=good["id"] as! String,x=m+CGFloat(i%2)*(cw+gap),y=top+CGFloat(i/2)*(ch+gap)
 frame(CGRect(x:x,y:y,width:cw,height:ch));icon(id,CGRect(x:x+pad,y:y+pad,width:target-pad,height:target-pad));paint((id=="cloth" ? "✓ ":"")+langs["AZ"]![id]!,"sectionTitle",x+target+pad,y+pad,cw-target-2*pad)
 paint("Al \(good["buyUnit"]!) · Sat \(good["sellUnitUndamaged"]!)\nEhtiyat \(good["stock"]!) · Səndə \(id=="cloth" ? 8:0)\nVahid yük \(good["unitLoad"]!) · Detala keç →","supporting",x+pad,y+target,cw-2*pad)
 }
 },path)
 verification.append(["screen":"D1/cards-\(page+1)","path":path,"allFit":true,"minimumActionTargetPx":target])
}
// Language/font/inset stress for the shared shell: no silent font fallback.
for lang in ["AZ","TR","RU","EN"] {for fs in [1.0,1.3,2.0] {for variant in [0,1,2] {
 scale=fs
 let l=langs[lang]!,left=variant==2 ? target:m,right=variant==1 ? target:m,w:CGFloat=1280
 let width=w-left-right
 let items=[l["cloth"]!,l["openDetails"]!.replacingOccurrences(of:"{good}",with:l["dragon_resin"]!),l["buyMax"]!.replacingOccurrences(of:"{max}",with:"999999"),l["sellMax"]!.replacingOccurrences(of:"{max}",with:"999999")]
 for page in 0..<2 {
 let path="\(out)/D6-\(lang)-\(fs)x-I\(variant)-\(page+1).png"
 var yy=g("safeTop"),fits=true
 save(bitmap(1280,720){
 box(CGRect(x:0,y:0,width:1280,height:720),"nav")
 for text in items.dropFirst(page*2).prefix(2) {
  let hh=max(target,shape(text,"label",width-2*pad).height+pad)
  if yy+hh>720-g("safeBottom"){fits=false;break}
  frame(CGRect(x:left,y:yy,width:width,height:hh));paint(text,"label",left+pad,yy+pad/2,width-2*pad);yy+=hh+gap
 }
 },path)
 verification.append(["screen":"D6/\(lang)/\(fs)/I\(variant)","path":path,"allFit":fits,"fontScale":fs,"leftInsetPx":left,"rightInsetPx":right,"minimumActionTargetPx":target,"scope":"Shared shell stress, not a full D1–D5 localization matrix"])
}}}}
scale=1

// Three actual visual frames per motion mode; same stored state in reduced mode.
for mode in ["normal","reduced"] {
 let path="\(out)/D6-motion-\(mode).png"
 save(bitmap(1280,720){
 box(CGRect(x:0,y:0,width:1280,height:720),"nav")
 frame(CGRect(x:m,y:g("safeTop"),width:1232,height:target));paint(mode=="normal" ? "Səyahət · Normal hərəkət":"Səyahət · Azaldılmış hərəkət","screenTitle",2*m,g("safeTop")+pad,1184)
 let cw=(1280-2*m-2*gap)/3,top=g("safeTop")+target+gap
 for i in 0..<3 {let x=m+CGFloat(i)*(cw+gap)
 frame(CGRect(x:x,y:top,width:cw,height:720-top-g("safeBottom")))
 crop("panorama",CGRect(x:x+g("frameEdge"),y:top+g("frameEdge"),width:cw-2*g("frameEdge"),height:g("artHeight")))
 paint(["1 · Yola çıxış","2 · Yoldasan","3 · Hadisə"][i],"sectionTitle",x+pad,top+g("artHeight")+gap,cw-2*pad)
 let roadY=top+g("artHeight")+2*target
 box(CGRect(x:x+pad,y:roadY,width:cw-2*pad,height:g("frameEdge")),"ink")
 let cartX=x+pad+(mode=="reduced" ? cw/3:CGFloat(i)*(cw-3*target)/2)
 box(CGRect(x:cartX,y:roadY-target/2,width:target,height:target/2),"nav")
 box(CGRect(x:cartX+pad/2,y:roadY-target/2+pad/2,width:target-pad,height:pad),"paper")
 for wheel in [cartX+pad/2,cartX+target-pad] {box(CGRect(x:wheel,y:roadY,width:pad,height:pad),"nav")}
 paint(["Gün 4 · Saxlanıb","Gün 5 · Saxlanıb","Dayandı · Qərar gözləyir"][i],"supporting",x+pad,roadY+target/2,cw-2*pad)
 paint(mode=="reduced" ? "Statik status":"Hərəkət yalnız təqdimatdır","supporting",x+pad,roadY+target,cw-2*pad)
 }
 },path)
 verification.append(["screen":"D6/motion-\(mode)","path":path,"allFit":true,"scope":"Visual storyboard, no executable animation"])
}

// Canonical two-pane compositions, complementing state-by-state scroll captures.
struct Pane {let title:String;let lines:[String]}
let compositions:[(String,String,Pane,Pane,String,String)]=[
 ("D3-loan-canonical","Kreditor · Borca baxış",Pane(title:"Məbləğ 100 qızıl",lines:["−10       +10","Qızıl 240 → 340","Cari gün 4"]),Pane(title:"Qaytarılacaq 110",lines:["Sabit haqq 10","Son tarix: gün 9","Qalıq borc 0 → 110"]),"Qəbul et","Ləğv"),
 ("D4-news-canonical","Xəbərlər · Gün 7",Pane(title:"Xəbər siyahısı",lines:["✓ Yaşıldərə · Şayiə","Yol taciri · Gün 6","Sünbülova · Yerli fakt"]),Pane(title:"Təsdiqlənməyib",lines:["Ot tələbi arta bilər.","Köhnəlir: gün 8","Yerli tarixçədən yoxla."]),"Şəhərə bax","Xəritəyə qayıt"),
 ("D2-services-canonical","Yol xidmətləri · Seçilməyib · Cəm 0",Pane(title:"□ Bələdçi",lines:["Bir yol: 4 × məsafə","4 gün: 12 qızıl","Gecikmə ehtimalı −50%"]),Pane(title:"□ Mühafizəçi",lines:["Bir yol: 10 × məsafə","4 gün: 28 qızıl","Quldur ehtimalı −50%"]),"Seçimə bax","Marşruta qayıt"),
 ("D5-delete-confirm","Hesabı sil · Son təsdiq",Pane(title:"Bu oyunun məlumatları",lines:["Saxlamalar silinəcək.","İctimai nəticələr silinəcək.","Eyni hesabla giriş tələb olunur."]),Pane(title:"Alışlar köçürülmür",lines:["Yeni hesaba bərpa yoxdur.","Google hesabın silinmir.","Play sifarişin silinmir."]),"Hesabı sil","Ləğv"),
 ("D5-final-canonical","Xalis sərvət · 480 qızıl",Pane(title:"Hesablaşma",lines:["Qızıl                  430","Yük satışı          +160","Borc                 −110"]),Pane(title:"Classic · Balans v1",lines:["Vaxtında · Geri dönüşsüz","Şəxsi nəticə saxlanıb.","Online: göndərilir"]),"Əsas menyu","Detallı dəftər")
]
for (id,title,left,right,primary,secondary) in compositions {
 let path="\(out)/\(id).png",cw=(1280-2*m-gap)/2,top=g("safeTop")+target+gap
 save(bitmap(1280,720){
 box(CGRect(x:0,y:0,width:1280,height:720),"nav");frame(CGRect(x:m,y:g("safeTop"),width:1232,height:target));paint(title,"screenTitle",2*m,g("safeTop")+pad,1184)
 for (i,pane) in [left,right].enumerated(){let x=m+CGFloat(i)*(cw+gap);frame(CGRect(x:x,y:top,width:cw,height:720-top-g("safeBottom")-target-gap));paint(pane.title,"sectionTitle",x+pad,top+pad,cw-2*pad)
 var lineY=top+target
 for line in pane.lines {paint(line,"body",x+pad,lineY,cw-2*pad);lineY+=shape(line,"body",cw-2*pad).height+pad/2}
 }
 control(primary,CGRect(x:m,y:720-g("safeBottom")-target,width:cw,height:target));control(secondary,CGRect(x:m+cw+gap,y:720-g("safeBottom")-target,width:cw,height:target))
 },path)
 verification.append(["screen":String(id.prefix(2))+"/"+id,"path":path,"allFit":true,"minimumActionTargetPx":target,"scope":"Canonical static two-pane composition"])
}
for category in ["actions","statuses"] {
 let path="\(out)/D6-components-\(category).png",cw=(1280-2*m-gap)/2
 save(bitmap(1280,720){
 box(CGRect(x:0,y:0,width:1280,height:720),"nav");frame(CGRect(x:m,y:g("safeTop"),width:1232,height:target));paint(category=="actions" ? "Əməliyyat · Bütün vəziyyətlər":"Saxlama və partiya statusları","screenTitle",2*m,g("safeTop")+pad,1184)
 let texts=category=="actions" ? ["Al 70 · Normal","Al 70 · Fokusda","Al 70 · Basılıb","Yazılır… · Təkrar bağlı","Al — pul çatmır","Sat 56 · Aktiv"]:["✓ Lokal saxlanıb","Bulud əlaqə gözləyir","Buludda saxlanıb","! Nəticə naməlum","✓ Sağlam · 100% · 5","Zədəli · 60% · 3"]
 for (i,text) in texts.enumerated(){let r=CGRect(x:m+CGFloat(i%2)*(cw+gap),y:g("safeTop")+target+gap+CGFloat(i/2)*(target+2*gap),width:cw,height:target)
 control(text,r,category=="actions" && i != 4)
 if category=="actions" && i==1 {let inner=r.insetBy(dx:g("frameEdge")/2,dy:g("frameEdge")/2);color("paper").setStroke();let path=NSBezierPath(rect:inner);path.lineWidth=g("frameEdge")/2;path.stroke()}
 if category=="actions" && i==2 {box(CGRect(x:r.minX+pad,y:r.maxY-pad,width:r.width-2*pad,height:g("frameEdge")/2),"paper")}
 }
 },path)
 verification.append(["screen":"D6/components-\(category)","path":path,"allFit":true,"minimumActionTargetPx":target,"scope":"Static component appearances; semantics not implemented"])
}

let result:[String:Any]=["captures":verification,"missingGlyphs":missing,"allFit":verification.allSatisfy{$0["allFit"] as! Bool},"gameCodeChanged":false,"scope":"Static screen designs. Pagination is presentation of scroll content, not implemented navigation. Runtime, device, touch and TalkBack remain untested."]
try! JSONSerialization.data(withJSONObject:result,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(out)/verification.json"))
print("captures=\(verification.count) missing=\(missing) allFit=\(verification.allSatisfy{$0["allFit"] as! Bool})")
