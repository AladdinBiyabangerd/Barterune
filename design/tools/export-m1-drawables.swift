// Exports the reviewed D1 composition crops (D1-pixel-composition-tokens.json + atlas v13) as app drawables.
// Run from repo root: swift design/tools/export-m1-drawables.swift
import AppKit
func read(_ p:String)->[String:Any]{try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:p))) as! [String:Any]}
func image(_ p:String)->CGImage{NSImage(contentsOfFile:p)!.cgImage(forProposedRect:nil,context:nil,hints:nil)!}
let out="core/designsystem/src/main/res/drawable-nodpi"
let art=read("design/states/D1-pixel-composition-tokens.json")["art"] as! [String:Any]
let source=image(art["source"] as! String), iconSource=image(art["iconSource"] as! String)
func write(_ im:CGImage,_ name:String){
 let rep=NSBitmapImageRep(cgImage:im);try! rep.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:"\(out)/\(name).png"))
}
for (key,name) in [("panorama","market_panorama"),("frameTop","frame_top"),("frameBottom","frame_bottom"),("frameLeft","frame_left"),("frameRight","frame_right")] {
 let a=art[key] as! [Int];write(source.cropping(to:CGRect(x:a[0],y:a[1],width:a[2],height:a[3]))!,name)
}
for key in ["cloth","grain","wood"] {let a=art[key] as! [Int];write(iconSource.cropping(to:CGRect(x:a[0],y:a[1],width:a[2],height:a[3]))!,"good_\(key)")}
let atlasPath=read("design/states/atlas-normalized-v13/review.json")["normalizedAtlas"] as! String
let atlas=image(atlasPath),unit=atlas.width/4
for (id,index) in ["spices":0,"iron":1,"salt":2,"wool":3,"herbs":4,"mana_crystal":5,"dragon_resin":6] {
 write(atlas.cropping(to:CGRect(x:(index%4)*unit,y:(index/4)*unit,width:unit,height:unit))!,"good_\(id)")
}
print("exported to \(out)")
