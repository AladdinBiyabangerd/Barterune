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

let tokens=read("design/states/D5-entry-trial-tokens.json")
let geo=tokens["geometry"] as! [String:Int]
let matrix=read("design/states/D1-canonical-render-matrix.json")
let profiles=matrix["profiles"] as! [[String:Any]]
let langs=read("design/states/D1-render-localization.json")["languages"] as! [String:[String:String]]
let goods=(read("design/states/D1-render-fixture.json")["base"] as! [String:Any])["goods"] as! [[String:Any]]
let gap=CGFloat(geo["gap"]!),inset=CGFloat(geo["textInset"]!),target=CGFloat(geo["buttonHeight"]!)
let out="design/states/D1-inventory-canonical-v3"
try! FileManager.default.createDirectory(atPath:out,withIntermediateDirectories:true)
struct Block {let text:String;let role:String;let rect:CGRect;let action:Bool;let selected:Bool}
var reports:[[String:Any]]=[]
for profile in profiles {
 let pid=profile["id"] as! String,px=profile["outputPx"] as! [Int],density=profile["density"] as! Int
 // The shaping helper uses the existing 2x source scale. P2 is rendered at native 3x using a context transform.
 let factor=CGFloat(density)/2,w=CGFloat(px[0])/factor,h=CGFloat(px[1])/factor
 let safe=profile["safeInsetsDp"] as! [String:Int]
 let left=CGFloat(safe["left"]!*2)+inset,right=w-CGFloat(safe["right"]!*2)-inset
 let top=CGFloat(safe["top"]!*2),bottom=h-CGFloat(safe["bottom"]!*2)
 for lang in ["AZ","TR","RU","EN"] {let l=langs[lang]!
 func t(_ key:String)->String{l[key]!}
 for fs in [1.0,1.3,2.0] {scale=fs
 for mode in ["list","cards"] {
 let name="\(pid)-\(lang)-\(fs)x-\(mode)",dir="\(out)/\(name)"
 try! FileManager.default.createDirectory(atPath:dir,withIntermediateDirectories:true)
 let width=right-left
 let title=t("market")+" · "+t("city")
 let titleH=shape(title,"screenTitle",width-2*inset).height+2*inset
 let hud=t("day").replacingOccurrences(of:"{day}",with:"4").replacingOccurrences(of:"{totalDays}",with:"20")+" · "+t("gold")+" 500 · "+t("load")+" 16/40"
 let hudH=shape(hud,"numeric",width).height
 let viewTop=top+titleH+gap+hudH+gap
 let viewHeight=bottom-viewTop
 precondition(viewHeight>target+2*inset)
 var blocks:[Block]=[],y:CGFloat=0
 func add(_ text:String,_ role:String="body",_ action:Bool=false,_ bx:CGFloat?=nil,_ bw:CGFloat?=nil,_ by:CGFloat?=nil,_ selected:Bool=false)->CGFloat {
 let ww=bw ?? width,xx=bx ?? left,yy=by ?? y
 let padding=action ? inset:0
 let hh=max(action ? target:0,shape(text,role,ww-2*inset).height+2*padding)
 blocks.append(Block(text:text,role:role,rect:CGRect(x:xx,y:yy,width:ww,height:hh),action:action,selected:selected))
 if by==nil{y+=hh+gap};return hh
 }
 _=add(t(mode)+" · "+t("goods"),"sectionTitle")
 // Switcher and service entries are part of the scroll flow: never cover the goods.
 
 let columns=(mode=="cards" && fs<2 && width>=CGFloat(geo["width"]!)-2*inset) ? 2:1
 let cw=(width-gap*CGFloat(columns-1))/CGFloat(columns)
 for start in stride(from:0,to:goods.count,by:columns){let rowY=y;var rowHeight:CGFloat=0
 for col in 0..<columns where start+col<goods.count {
 let good=goods[start+col],id=good["id"] as! String,selected=id=="cloth",bx=left+CGFloat(col)*(cw+gap)
 var yy=rowY
 let rows:[(String,String,Bool)]=[(t(id)+(selected ? " · ✓ "+t("selected"):""),"sectionTitle",false),(t("buyUnit")+": \(good["buyUnit"]!) · "+t("sellUnit")+": \(good["sellUnitUndamaged"]!)","numeric",false),(t("stock")+": \(good["stock"]!) · "+t("owned")+": \(selected ? 8:0) · "+t("unitLoad")+": \(good["unitLoad"]!)","body",false),(t("openDetails").replacingOccurrences(of:"{good}",with:t(id)),"label",true)]
 for (text,role,action) in rows {yy+=add(text,role,action,bx,cw,yy,selected)+CGFloat((tokens["spacingTrialDp"] as! [Int])[0]*2)}
 rowHeight=max(rowHeight,yy-rowY)
 }
 y=rowY+rowHeight+gap
 }
 for key in ["switchView","workshop","creditor","hire","map","cargo"]{_=add(t(key),"label",true)}
 let contentHeight=y-gap,maxOffset=max(0,contentHeight-viewHeight)
 var offsets:[CGFloat]=[0]
 while offsets.last!<maxOffset{offsets.append(min(maxOffset,offsets.last!+viewHeight-target))}
 for b in blocks where b.action{if !offsets.contains(where:{b.rect.minY >= $0 && b.rect.maxY <= $0+viewHeight}){offsets.append(min(maxOffset,b.rect.minY))}}
 offsets=Array(Set(offsets)).sorted()
 var checks:[[String:Any]]=[]
 for b in blocks {let sh=shape(b.text,b.role,b.rect.width-2*inset)
 let padding=b.action ? inset:0
 let covered=(0..<sh.lines.count).allSatisfy{i in let yy=b.rect.minY+padding+CGFloat(i)*sh.step;return offsets.contains{yy >= $0 && yy+sh.step <= $0+viewHeight}}
 checks.append(["text":b.text,"rect":[b.rect.minX,b.rect.minY,b.rect.width,b.rect.height],"fits":sh.maxWidth<=b.rect.width-2*inset+0.01 && sh.height+2*padding<=b.rect.height+0.01,"linesVisible":covered,"target48dp": !b.action || (b.rect.height>=target && b.rect.width>=target),"controlVisible": !b.action || offsets.contains{b.rect.minY >= $0 && b.rect.maxY <= $0+viewHeight}])}
 let overlap=blocks.enumerated().contains{i,b in blocks.dropFirst(i+1).contains{b.rect.intersects($0.rect)}}
 var paths:[String]=[]
 for (page,offset) in offsets.enumerated(){let path="\(dir)/scroll-\(page).png";paths.append(path)
 save(bitmap(px[0],px[1]){
 let ctx=NSGraphicsContext.current!.cgContext;ctx.scaleBy(x:factor,y:factor)
 box(CGRect(x:0,y:0,width:w,height:h),"paper")
 box(CGRect(x:left,y:top,width:width,height:titleH),"nav");paint(title,"screenTitle",left+inset,top+inset,width-2*inset,"paper")
 paint(hud,"numeric",left,top+titleH+gap,width)
 ctx.saveGState();ctx.clip(to:CGRect(x:left,y:viewTop,width:width,height:viewHeight));ctx.translateBy(x:0,y:viewTop-offset)
 for b in blocks {
 if b.action {box(b.rect,"nav")}
 else if b.selected {box(CGRect(x:b.rect.minX,y:b.rect.minY,width:CGFloat((tokens["spacingTrialDp"] as! [Int])[0]*2),height:b.rect.height),"ink")}
 paint(b.text,b.role,b.rect.minX+inset,b.rect.minY+(b.action ? inset:0),b.rect.width-2*inset,b.action ? "paper":"nav")
 }
 ctx.restoreGState()
 },path)
 }
 reports.append(["profile":name,"goods":goods.map{$0["id"]!},"columns":columns,"captures":paths,"offsets":offsets,"noOverlap": !overlap,"checks":checks,"allChecksPassed": !overlap && checks.allSatisfy{($0["fits"] as! Bool) && ($0["linesVisible"] as! Bool) && ($0["target48dp"] as! Bool) && ($0["controlVisible"] as! Bool)}])
 print("\(name): \(paths.count)")
 }
 }
 }
}
let result:[String:Any]=["scope":"D1 inventory list/cards; other D1 sections remain separate","profiles":reports,"missingGlyphs":missing,"fontHash":f["sha256"]!,"allChecksPassed":missing==0 && reports.allSatisfy{$0["allChecksPassed"] as! Bool},"limits":["Synthetic static scaling, not Android runtime","Native translation review pending","Historical fixture prices are render data, not balance","No transaction or navigation implementation","Flat palette style; pixel panorama/art integration still pending"]]
try! JSONSerialization.data(withJSONObject:result,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(out)/verification.json"))
print("allChecksPassed=\(result["allChecksPassed"]!), missingGlyphs=\(missing)")
