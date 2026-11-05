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
func save(_ b:NSBitmapImageRep,_ p:String){try! b.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:p))}

// Art integration into a static screen renderer; no gameplay implementation.
let tok=read("design/states/D1-pixel-composition-tokens.json"),geo=read("design/states/D1-pixel-composition-tokens.json")["geometry"] as! [String:Int]
let art=tok["art"] as! [String:Any]
let source=NSImage(contentsOfFile:art["source"] as! String)!.cgImage(forProposedRect:nil,context:nil,hints:nil)!
func g(_ k:String)->CGFloat{CGFloat(geo[k]!)*density/2}
func crop(_ key:String,_ r:CGRect){let a=art[key] as! [Int];let src=["cloth","wood","grain"].contains(key) ? NSImage(contentsOfFile:art["iconSource"] as! String)!.cgImage(forProposedRect:nil,context:nil,hints:nil)!:source;let im=src.cropping(to:CGRect(x:a[0],y:a[1],width:a[2],height:a[3]))!;let c=NSGraphicsContext.current!.cgContext;c.saveGState();c.interpolationQuality = .none;c.translateBy(x:r.minX,y:r.maxY);c.scaleBy(x:1,y:-1);c.draw(im,in:CGRect(origin:.zero,size:r.size));c.restoreGState()}
func frame(_ r:CGRect){box(r,"paper");let e=g("frameEdge");crop("frameTop",CGRect(x:r.minX,y:r.minY,width:r.width,height:e));crop("frameBottom",CGRect(x:r.minX,y:r.maxY-e,width:r.width,height:e));crop("frameLeft",CGRect(x:r.minX,y:r.minY+e,width:e,height:r.height-2*e));crop("frameRight",CGRect(x:r.maxX-e,y:r.minY+e,width:e,height:r.height-2*e))}
let out="design/states/D2-payment-matrix-v15"
try! FileManager.default.createDirectory(atPath:out,withIntermediateDirectories:true)
let matrix=read("design/states/D1-canonical-render-matrix.json")
let profiles=matrix["profiles"] as! [[String:Any]]
let localization=read("design/states/D2-payment-localization-v15.json")["languages"] as! [String:[String:String]]
let variants=read("design/states/D2-payment-modes-v15-fixtures.json")["variants"] as! [[String:Any]]
var results=[[String:Any]](), captures=0
let filter=CommandLine.arguments.dropFirst().first
for profile in profiles {
 let pid=profile["id"] as! String
 if let filter=filter,filter != pid {continue}
 density=CGFloat(profile["density"] as! Int)
 let size=profile["outputPx"] as! [Int],w=CGFloat(size[0]),h=CGFloat(size[1])
 for insetID in (pid == "P3" ? [0]:[0,1,2]) {
 var ins=profile["safeInsetsDp"] as! [String:Int]
 if insetID>0 {ins=(matrix["insetVariants"] as! [[String:Any]])[insetID]["safeInsetsDp"] as! [String:Int]}
 let left=CGFloat(ins["left"]!)*density+g("margin"),right=CGFloat(ins["right"]!)*density+g("margin")
 let top=CGFloat(ins["top"]!)*density+g("margin"),bottom=h-CGFloat(ins["bottom"]!)*density-g("margin")
 let width=min(w-left-right,g("maxTextWidth")),x=left+(w-left-right-width)/2,pad=g("inset"),gap=g("gap"),target=g("target")
 for lang in ["AZ","TR","RU","EN"] {for fs in [1.0,1.3,2.0] {
 scale=fs*Double(density)/2
 for v in variants {autoreleasepool {
 let id=v["id"] as! String,l=localization[lang]!
 func t(_ s:String)->String {precondition(l[s] != nil,"Missing translation: \(s)");return l[s]!}
 var blocks=[(String,String,Bool)]()
 blocks.append((t(v["title"] as! String),"screenTitle",false))
 blocks.append((t(v["status"] as! String),"supporting",false))
 for pane in ["left","right"] {for (i,s) in (v[pane] as! [String]).enumerated(){blocks.append((t(s),i==0 ? "sectionTitle":"body",false))}}
 blocks.append((t(v["primary"] as! String),"label",v["enabled"] as! Bool))
 blocks.append((t("← Geri"),"label",false))
 // All content, including actions, is in the static scroll flow; no shrinking or clipping.
 var pages=[[(String,String,Bool,CGFloat)]](),current=[(String,String,Bool,CGFloat)](),y=top,fit=true,maxWidth:CGFloat=0
 for (text,role,active) in blocks {
 let shaped=shape(text,role,width-2*pad)
 let bh=max(role == "label" ? target:0,shaped.height+pad)
 maxWidth=max(maxWidth,shaped.maxWidth)
 if y+bh>bottom && !current.isEmpty {pages.append(current);current=[];y=top}
 fit = fit && y+bh<=bottom && shaped.maxWidth<=width-2*pad+0.01
 current.append((text,role,active,bh));y+=bh+gap
 }
 if !current.isEmpty {pages.append(current)}
 let cell="\(pid)-I\(insetID)-\(lang)-\(fs)x"
 let folder="\(out)/\(cell)"
 try! FileManager.default.createDirectory(atPath:folder,withIntermediateDirectories:true)
 var paths=[String]()
 for (page,blocks) in pages.enumerated() {
 let path="\(folder)/\(id)-\(page).png"
 save(bitmap(size[0],size[1]){
 box(CGRect(x:0,y:0,width:w,height:h),"nav");var yy=top
 for (text,role,active,bh) in blocks {
 frame(CGRect(x:x,y:yy,width:width,height:bh))
 if active {box(CGRect(x:x+g("frameEdge"),y:yy+g("frameEdge"),width:width-2*g("frameEdge"),height:bh-2*g("frameEdge")),"nav")}
 paint(text,role,x+pad,yy+pad/2,width-2*pad,active ? "paper":"nav");yy+=bh+gap
 }
 },path)
 paths.append(path);captures+=1
 }
 results.append(["profile":pid,"inset":"I\(insetID)","language":lang,"fontScale":fs,"font":"F1/NotoSans","fixture":id,"operationId":v["operationId"]!,"allFit":fit,"pages":paths,"minimumTargetPx":target,"safeInsetsDp":ins,"outputPx":size,"maxTextWidthPx":maxWidth])
 }}
 print("\(pid) I\(insetID) \(lang) \(fs): \(results.count) cases / \(captures) pages")
 }}
 }
}
let result:[String:Any]=["caseCount":results.count,"captures":captures,"allFit":results.allSatisfy{$0["allFit"] as! Bool},"missingGlyphs":missing,"resolvedFonts":resolved.sorted(),"cases":results,"scope":"Static adaptive stacked payment flow, paginated scroll presentation; F1 canonical NotoSans only, linear font-scale simulation. Draft TR/RU/EN copy. Not runtime or physical device proof; does not replace canonical V15 images.","gameCodeChanged":false]
try! JSONSerialization.data(withJSONObject:result,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(out)/verification-\(filter ?? "all").json"))
