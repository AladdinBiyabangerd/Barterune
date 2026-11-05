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
let profiles=read("design/states/D1-canonical-render-matrix.json")["profiles"] as! [[String:Any]]
let out="design/states/D1-keypad-fixed-v16"
let states=[("quantity","2","editing"),("empty","—","minimum"),("zero","0","minimum"),("negative","−2","minimum"),("decimal","2.5","wholeNumbers"),("seven-digits","1234567","digitCap")]
var reports:[[String:Any]]=[]
for profile in profiles {for lang in ["AZ","EN","RU","TR"] {for fs in [1.0,1.3,2.0] {for (state,value,reason) in states {autoreleasepool {
 scale=fs
 let pid=profile["id"] as! String,px=profile["outputPx"] as! [Int],density=profile["density"] as! Int
 let safe=profile["safeInsetsDp"] as! [String:Int],factor=CGFloat(density)/2
 let w=CGFloat(px[0])/factor,h=CGFloat(px[1])/factor
 let left=CGFloat(safe["left"]!*2)+g("margin"),right=w-CGFloat(safe["right"]!*2)-g("margin")
 let top=CGFloat(safe["top"]!*2),bottom=h-CGFloat(safe["bottom"]!*2)
 let tablet=pid=="P3",gap=g("gap"),pad=g("inset"),target=g("target")
 let totalW=tablet ? min(right-left,2*g("maxTextWidth")):right-left
 let origin=tablet ? (left+right-totalW)/2:left
 let paneW=(totalW-gap)/2,rx=origin+paneW+gap
 let keyW=(paneW-2*gap)/3
 let keyH=max(target,shape("0","numeric",keyW-2*pad).height)
 let fieldH=max(target,shape(value,"numeric",paneW-2*pad).height)
 let gridH=4*keyH+3*gap,blockH=fieldH+gap+gridH
 let gridTop=tablet ? top+(bottom-top-blockH)/2:top
 let field=CGRect(x:rx,y:gridTop,width:paneW,height:fieldH)
 let backText="← "+langs[lang]!["back"]!
 let backH=max(target,shape(backText,"label",paneW-2*pad).height+pad)
 let back=CGRect(x:origin,y:bottom-backH,width:paneW,height:backH)
 let title=langs[lang]!["enterQuantity"]!,reasonText=langs[lang]![reason]!
 var lines:[(String,String,CGRect)]=[],yy=top
 for (text,role) in [(title,"label"),(langs[lang]!["cloth"]!,"sectionTitle"),(reasonText,"supporting")] {
  let sh=shape(text,role,paneW-2*pad)
  lines.append((text,role,CGRect(x:origin,y:yy,width:paneW,height:sh.height+pad)));yy+=sh.height+pad+gap
 }
 // Fixed footer and fixed keypad are independent of content scroll.
 let infoBottom=back.minY-gap,infoH=infoBottom-top
 var offsets:[CGFloat]=[0]
 let maxOff=max(0,yy-gap-top-infoH)
 while offsets.last!<maxOff {offsets.append(min(maxOff,offsets.last!+max(target,infoH-target)))}
 var controls:[(String,CGRect,Bool)]=[(backText,back,true)]
 for (i,key) in ["1","2","3","4","5","6","7","8","9","←","0","✓"].enumerated() {
  controls.append((key,CGRect(x:rx+CGFloat(i%3)*(keyW+gap),y:field.maxY+gap+CGFloat(i/3)*(keyH+gap),width:keyW,height:keyH),key != "✓" || state=="quantity"))
 }
 let bounds=CGRect(x:left,y:top,width:right-left,height:bottom-top)
 let geometryFit=bounds.contains(field) && controls.allSatisfy{bounds.contains($0.1) && $0.1.width>=target && $0.1.height>=target}
 let overlap=controls.enumerated().contains{i,a in controls.dropFirst(i+1).contains{a.1.intersects($0.1)}}
 let infoFit=lines.allSatisfy{text,role,r in let sh=shape(text,role,r.width-2*pad);return (0..<sh.lines.count).allSatisfy{i in let y=r.minY+pad/2+CGFloat(i)*sh.step;return offsets.contains{y-$0>=top && y-$0+sh.step<=infoBottom}}}
 var paths:[String]=[]
 let name="\(pid)-\(lang)-\(fs)x-\(state)"
 for (page,offset) in offsets.enumerated() {
  let path="\(out)/\(name)-\(page).png";paths.append(path)
  save(bitmap(px[0],px[1]){
   let c=NSGraphicsContext.current!.cgContext;c.scaleBy(x:factor,y:factor)
   box(CGRect(x:0,y:0,width:w,height:h),"nav")
   box(CGRect(x:origin,y:top,width:paneW,height:infoH),"paper")
   c.saveGState();c.clip(to:CGRect(x:origin,y:top,width:paneW,height:infoH));c.translateBy(x:0,y:-offset)
   for (text,role,r) in lines {paint(text,role,r.minX+pad,r.minY+pad/2,r.width-2*pad)}
   c.restoreGState()
   box(field,"paper");paint(value,"numeric",field.minX+pad,field.minY+(field.height-shape(value,"numeric",field.width-2*pad).height)/2,field.width-2*pad)
   for (text,r,enabled) in controls {
    frame(r)
    if enabled {box(CGRect(x:r.minX+g("frameEdge"),y:r.minY+g("frameEdge"),width:r.width-2*g("frameEdge"),height:r.height-2*g("frameEdge")),"nav")}
    let role=text==backText ? "label":"numeric",sh=shape(text,role,r.width-2*pad)
    paint(text,role,r.minX+pad,r.minY+(r.height-sh.height)/2,r.width-2*pad,enabled ? "paper":"nav")
   }
  },path)
 }
 reports.append(["id":name,"layout":tablet ? "tablet-centered-two-pane":"phone-split-fixed-keypad","captures":paths,"allFit":geometryFit && !overlap && infoFit,"fixedControls":controls.map{["text":$0.0,"rect":[$0.1.minX,$0.1.minY,$0.1.width,$0.1.height],"enabled":$0.2]},"backBehavior":"Cancel edit; restore prior quantity; return to originating detail or preview; never transact","applyEnabled":state=="quantity"])
}}}}}
let result:[String:Any]=["cases":reports,"allFit":reports.allSatisfy{$0["allFit"] as! Bool},"missingGlyphs":missing,"scope":"Static fixed keypad and back; left instructions may scroll. No runtime or nonlinear Android scale proof."]
try! JSONSerialization.data(withJSONObject:result,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(out)/verification.json"))
print("cases=\(reports.count) allFit=\(result["allFit"]!) missing=\(missing)")
