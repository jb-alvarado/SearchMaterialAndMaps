/*
----------------------------------------------------------------------------------------------------------------------
::
::    Description: This MaxScript is for collecting materials and texture, searching by name, 
::	   	   modify the texture path and copy the selection in the material editor.
::
----------------------------------------------------------------------------------------------------------------------
:: LICENSE ----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
::
::    Copyright (C) 2013 Jonathan Baecker (jb_alvarado)
::
::    This program is free software: you can redistribute it and/or modify
::    it under the terms of the GNU General Public License as published by
::    the Free Software Foundation, either version 3 of the License, or
::    (at your option) any later version.
::
::    This program is distributed in the hope that it will be useful,
::    but WITHOUT ANY WARRANTY; without even the implied warranty of
::    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
::    GNU General Public License for more details.
::
::    You should have received a copy of the GNU General Public License
::    along with this program.  If not, see <http://www.gnu.org/licenses/>.
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
:: History --------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
::
:: This is version 1.0 from 2013-06-09. Last bigger modification was on 2014-02-04
:: 2013-05-27: build the script
:: 2013-06-01: rewrite and optimize the code (Jonathan Baecker)
:: 2013-06-02: Add support for multiple texture selections (Jonathan Baecker)
:: 2013-06-04: Add list filter options, and select object by material (Jonathan Baecker)
:: 2013-06-05: Add missing texture filter and small changes (Jonathan Baecker)
:: 2013-06-06: Optimize the search command and add a sort function for the texture list (Jonathan Baecker)
:: 2013-06-07: Add a sort function for the material list (Jonathan Baecker)
:: 2013-06-09: Add show texture slot checkbox and show material and texture from selected objects (Jonathan Baecker)
:: 2014-02-04: change listview to dotnet, add right click menu and remove some buttons (Jonathan Baecker)
:: 2014-02-05: fix fillup map array and add vray2side material (Jonathan Baecker)
::
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
--
--  Script Name: Search Materials And Maps
--
--	Author:   Jonathan Baecker (jb_alvardo) www.pixelcrusher.de | blog.pixelcrusher.de
--
----------------------------------------------------------------------------------------------------------------------
*/
(
	global colMats = #()
	global colMatsS = #()
	global mapFiles= #()
	
-------------------------------------------------------------------
--Search texture by name function
-------------------------------------------------------------------

fn GetMaps mapName = (
	case classof mapName of (			
		compositeTextureMap: (
			join mapFiles #( mapName )
			
			for b = 1 to mapName.maplist.count do (
				if classof mapName.maplist[b] != Bitmaptexture then (
					GetMaps mapName.maplist[b]
					) else (
						join mapFiles #( mapName.maplist[b] )
						)
				)
			)
		
		cellular: (
			join mapFiles #( mapName )
			
			if mapName.cellmap != undefined do (
				if classof mapName.cellmap != Bitmaptexture then (
					GetMaps mapName.cellmap
					) else (
						join mapFiles #( mapName.cellmap )
						)
				)
			if mapName.divmap1 != undefined do (
				if classof mapName.divmap1 != Bitmaptexture then (
					GetMaps mapName.divmap1
					) else (
						join mapFiles #( mapName.divmap1 )
						)
				)
			if mapName.divmap2 != undefined do (
				if classof mapName.divmap2 != Bitmaptexture then (
					GetMaps mapName.divmap2
					) else (
						join mapFiles #( mapName.divmap2 )
						)
				)
			)
			
		mix: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)
			
		noise: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)	
			
		Smoke: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)
			
		Speckle: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)
		
		Checker: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)
		
		ColorCorrection: (
			join mapFiles #( mapName )
			
			if mapName.map != undefined do (
				if classof mapName.map != Bitmaptexture then (
					GetMaps mapName.map
					) else (
						join mapFiles #( mapName.map )
						)
				)	
			)
		
		Falloff: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
				
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)
			
		gradient: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)
			if mapName.map3 != undefined do (
				if classof mapName.map3 != Bitmaptexture then (
					GetMaps mapName.map3
					) else (
						join mapFiles #( mapName.map3 )
						)
				)
			)			
			
		bitmaptexture: (
			join mapFiles #( mapName )
			)
			
		default: (
			join mapFiles #( mapName )
			)
		)
	)
	
fn GetBitmaps mtl = (
	mapArray = #()
	for a = 1 to (getNumSubTexmaps mtl) do (
		if ((getSubTexmap mtl a) != undefined) do (
			mapName = (getSubTexmap mtl a)
			GetMaps mapName
			join mapArray #(mapFiles)
			mapFiles = #()
			)
		)

	for b = 1 to mapArray.count do (
		for c = 1 to mapArray[b].count do (
			join colMats #( colMatsS= #(mapArray[b][c] ) )
			join colMatsS #( classof mapArray[b][c] )
			if classof mapArray[b][c] == bitmaptexture then (
				if ( mapArray[b][c].filename == undefined OR mapArray[b][c].filename == "" ) then (
					join colMatsS #( "Warning: empty bitmap texture!" )
					) else (
						join colMatsS #( filenameFromPath mapArray[b][c].filename )
						)
				join colMatsS #( "tex" )
				) else (
					join colMatsS #( "       " + mapArray[b][c].name )
					join colMatsS #( "map" )
					)
			)
		)
	)

-------------------------------------------------------------------
--Search material by name function
-------------------------------------------------------------------
fn matlists mtl = (
	local checkType = #(Blend, CompositeMaterial, doubleSided, MultiMaterial, Shellac, Shell_Material, TopBottom, VRay2SidedMtl)
	
	case classof mtl of (
		--------------------------------------------------
		--Blend
		--------------------------------------------------
		Blend: (
			join colMats  #( colMatsS = #( mtl ) )
			join colMatsS #( mtl.name )
			join colMatsS #( "mat" )

			local blendMat = #()

			if (mtl.map1 != undefined ) do (
				if ( findItem checkType ( classof mtl.map1 ) == 1 ) then (
						matlists mtl.map1
						) else (
							join colMats  #( colMatsS = #( mtl.map1 ) )
							join colMatsS #( "    " + mtl.map1.name )
							join colMatsS #( "sub" )

							GetBitmaps mtl.map1
							)
				)
			if ( mtl.map2 != undefined ) do (
				if ( findItem checkType ( classof mtl.map2 ) == 1 ) then (
						matlists mtl.map2
						) else (
							join colMats  #( colMatsS = #( mtl.map2 ) )
							join colMatsS #( "    " + mtl.map2.name )
							join colMatsS #( "sub" )
								
							GetBitmaps mtl.map2
							)
				)
		)
		--------------------------------------------------
		--Shellac
		--------------------------------------------------
		Shellac: (
			join colMats  #( colMatsS = #( mtl ) )
			join colMatsS #( mtl.name )
			join colMatsS #( "mat" )

			if ( mtl.shellacMtl1 != undefined ) do (
				if ( findItem checkType ( classof mtl.shellacMtl1 ) == 1 ) then (
						matlists mtl.shellacMtl1
						) else (
							join colMats  #( colMatsS = #( mtl.shellacMtl1 ) )
							join colMatsS #( "    " + mtl.shellacMtl1.name )
							join colMatsS #( "sub" )

							GetBitmaps mtl.shellacMtl1
							)
				)
			if ( mtl.shellacMtl2 != undefined ) do (
				if ( findItem checkType ( classof mtl.shellacMtl2 ) == 1 ) then (
						matlists mtl.shellacMtl2
						) else (
							join colMats  #( colMatsS = #( mtl.shellacMtl2 ) )
							join colMatsS #( "    " + mtl.shellacMtl2.name )
							join colMatsS #( "sub" )

							GetBitmaps mtl.shellacMtl2
							)
				)
		)
		--------------------------------------------------
		--TopBottom 
		--------------------------------------------------
		TopBottom: (
			join colMats  #( colMatsS = #( mtl ) )
			join colMatsS #( mtl.name )
			join colMatsS #( "mat" )

			if ( mtl.topMaterial != undefined ) do (
				if ( findItem checkType ( classof mtl.topMaterial ) == 1 ) then (
						matlists mtl.topMaterial
						) else (
							join colMats  #( colMatsS = #( mtl.topMaterial ) )
							join colMatsS #( "    " + mtl.topMaterial.name )
							join colMatsS #( "sub" )	

							GetBitmaps mtl.topMaterial
							)
				)
			if ( mtl.bottomMaterial != undefined ) do (
				if ( findItem checkType ( classof mtl.bottomMaterial ) == 1 ) then (
						matlists mtl.bottomMaterial
						) else (
							join colMats  #( colMatsS = #( mtl.bottomMaterial ) )
							join colMatsS #( "    " + mtl.bottomMaterial.name )
							join colMatsS #( "sub" )

							GetBitmaps mtl.bottomMaterial
							)
				)
		)
		--------------------------------------------------
		--DoubleSided 
		--------------------------------------------------
		doubleSided: (
			join colMats  #( colMatsS = #( mtl ) )
			join colMatsS #( mtl.name )
			join colMatsS #( "mat" )

			if ( mtl.material1 != undefined ) do (
				if ( findItem checkType ( classof mtl.material1 ) == 1 ) then (
						matlists mtl.material1
						) else (
							join colMats  #( colMatsS = #( mtl.material1 ) )
							join colMatsS #( "    " + mtl.material1.name )
							join colMatsS #( "sub" )

							GetBitmaps mtl.material1
							)
				)
			if ( mtl.material2 != undefined ) do (
				if ( findItem checkType ( classof mtl.material2 ) == 1 ) then (
						matlists mtl.material2
						) else (
							join colMats  #( colMatsS = #( mtl.material2 ) )
							join colMatsS #( "    " + mtl.material2.name )
							join colMatsS #( "sub" )

							GetBitmaps mtl.material2	
							)
				)
		)
		--------------------------------------------------
		--VRay2Side
		--------------------------------------------------
		VRay2SidedMtl: (
			join colMats  #( colMatsS = #( mtl ) )
			join colMatsS #( mtl.name )
			join colMatsS #( "mat" )

			if ( mtl.frontMtl != undefined ) do (
				if ( findItem checkType ( classof mtl.frontMtl ) == 1 ) then (
						matlists mtl.frontMtl
						) else (
							join colMats  #( colMatsS = #( mtl.frontMtl ) )
							join colMatsS #( "    " + mtl.frontMtl.name )
							join colMatsS #( "sub" )

							GetBitmaps mtl.frontMtl
							)
				)
			if ( mtl.backMtl != undefined ) do (
				if ( findItem checkType ( classof mtl.backMtl ) == 1 ) then (
						matlists mtl.backMtl
						) else (
							join colMats  #( colMatsS = #( mtl.backMtl ) )
							join colMatsS #( "    " + mtl.backMtl.name )
							join colMatsS #( "sub" )

							GetBitmaps mtl.backMtl	
							)
				)
			if ( mtl.texmap_translucency != undefined ) do (
				GetBitmaps mtl
				)	
		)
		--------------------------------------------------
		--Shell_Material 
		--------------------------------------------------
		Shell_Material: (
			join colMats  #( colMatsS = #( mtl ) )
			join colMatsS #( mtl.name )
			join colMatsS #( "mat" )

			if ( mtl.originalMaterial != undefined ) do (
				if ( findItem checkType ( classof mtl.originalMaterial ) == 1 ) then (
						matlists mtl.originalMaterial
						) else (
							join colMats  #( colMatsS = #(mtl.originalMaterial ) )
							join colMatsS #( "    " + mtl.originalMaterial.name )
							join colMatsS #( "sub" )

							GetBitmaps mtl.originalMaterial
							)
				)
			if ( mtl.bakedMaterial != undefined ) do (
				if ( findItem checkType ( classof mtl.bakedMaterial ) == 1 ) then (
						matlists mtl.bakedMaterial
						) else (
							join colMats  #( colMatsS = #(mtl.bakedMaterial ) )
							join colMatsS #( "    " + mtl.bakedMaterial.name )
							join colMatsS #( "sub" )

							GetBitmaps mtl.bakedMaterial
							)
				)
		)
		--------------------------------------------------
		-- Multimaterials
		--------------------------------------------------
		MultiMaterial: (
			join colMats  #( colMatsS = #( mtl ) )
			join colMatsS #( mtl.name )
			join colMatsS #( "mat" )

			local m
			for m = 1 to mtl.numsubs do (
				if ( mtl[m] != undefined ) do (
					if ( findItem checkType ( classof mtl[m] ) == 1 ) then (
						matlists mtl[m]
						) else (
							join colMats  #( colMatsS = #(mtl[m] ) )
							join colMatsS #( "    " + mtl[m].name )
							join colMatsS #( "sub" )

							GetBitmaps mtl[m]
							)
					)
			)
		)
		--------------------------------------------------
		--CompositeMaterial
		--------------------------------------------------
		CompositeMaterial: (
			join colMats  #(colMatsS = #(mtl))
			join colMatsS #(mtl.name)
			join colMatsS #("mat")

			local c
			for c = 1 to mtl.materialList.count do (
				if ( mtl.materialList[c] != undefined ) do (
					if ( findItem checkType ( classof mtl.materialList[c] ) == 1 ) then (
						matlists mtl.materialList[c]
						) else (
							join colMats  #( colMatsS = #( mtl.materialList[c] ) )
							join colMatsS #( "    " + mtl.materialList[c].name )
							join colMatsS #( "sub" )

							GetBitmaps mtl.materialList[c]
							)
					)
			)
		)
		--------------------------------------------------
		--all other materials
		--------------------------------------------------
		default: (
			if ( superclassof mtl == material ) do (
				join colMats  #( colMatsS = #( mtl ) )
				join colMatsS #( mtl.name )
				join colMatsS #( "mat" )

				GetBitmaps mtl
				)
		)
			
		) --case end
		
	) --fn matlists end

try ( destroyDialog SearchMaterialAndMaps ) catch ( )	

rollout SearchMaterialAndMaps "Search Materials And Maps" width:340 height:650 (
	
		local ProgramName = "Search Material and Maps"
		local listVis = #()
		local listBG = #()
		local selectionArray = #()
		local selectionNums = #()
		local edtBoxText = ""

	groupBox grpProgress "Progress:" pos:[10,10] width:320 height:60
		label lblProgress "" pos:[20,30] width:200 height:16
		progressBar prgProgress "" pos:[20,49] width:235 height:12 color:[0,200,0]

	groupBox grpSeMyTex "Collection From All Materials And Maps:" pos:[10,75] width:320 height:515
		button btnSeMatAndTex "Collect Materials And Maps" pos:[20,95] width:160 height:20
		editText edtMat "" pos:[16,122] width:240 readOnly:true
		button btnChangeTex "Browse" pos:[260,122] width:60 height:18
		dotNetControl mlbxMatsAndTexs "system.windows.forms.listView" pos:[20,145] width:300 height:395
		checkBox chkMat "Show Materials" pos:[20,547] checked:true
		checkBox chkSub "Show Submaterials" pos:[115,547] checked:true
		checkBox chkMap "Show Maps" pos:[230,547] checked:true
		checkBox chkTex "Show Textures" pos:[20,567] checked:true
		checkBox chkmissing "Missing Texture" pos:[115,567] checked:false
		checkBox chkSelObj "From Selection" pos:[230,567] checked:false

	groupBox grpSeByName "Search Material And Maps By Name:" pos:[10,595] width:320 height:45
		editText edtBox text:"" pos:[16,613] width:244
		button btnSeMat "Search" pos:[270,613] width:50 height:20

	-----------------------------------------------
	--resize statment
	-----------------------------------------------
	on SearchMaterialAndMaps resized newSize do (

		grpProgress.width=newSize[1]-20

		grpSeMyTex.width=newSize[1]-20
		grpSeMyTex.height=newSize[2]-135
			edtMat.width=newSize[1]-105
			btnChangeTex.pos=[newSize[1]-80,122] 
			mlbxMatsAndTexs.width=newSize[1]-40
			mlbxMatsAndTexs.height=newSize[2]-254
		
			try (mlbxMatsAndTexs.columns.item[0].width = newSize[1]-64) catch ()
		
			chkMat.pos=[20,newSize[2]-103]
			chkSub.pos=[newSize[1]/2-55,newSize[2]-103]
			chkMap.pos=[newSize[1]-110,newSize[2]-103]
			chkTex.pos=[20,newSize[2]-83]
			chkmissing.pos=[newSize[1]/2-55,newSize[2]-83]
			chkSelObj.pos=[newSize[1]-110,newSize[2]-83]

		grpSeByName.width=newSize[1]-20
		grpSeByName.pos=[10, newSize[2]-55]
			edtBox.width=newSize[1]-100
			edtBox.pos=[20,newSize[2]-37]
			btnSeMat.pos=[newSize[1]-70,newSize[2]-37]
		)

	on SearchMaterialAndMaps open do (
		--Setup the forms view
		mlbxMatsAndTexs.HeaderStyle = none
		mlbxMatsAndTexs.columns.add "Material and Texture List" 278
		mlbxMatsAndTexs.view=(dotNetClass "system.windows.forms.view").details
		mlbxMatsAndTexs.FullRowSelect=true
		mlbxMatsAndTexs.GridLines=false
		mlbxMatsAndTexs.MultiSelect=true
		mlbxMatsAndTexs.allowdrop = true
		cb = ((colorman.getColor #background)*255+20) as color
		mlbxMatsAndTexs.BackColor = (dotNetClass "System.Drawing.Color").fromARGB cb.r cb.g cb.b
		cf = ((colorman.getColor #text)*255+30) as color
		mlbxMatsAndTexs.ForeColor = (dotNetClass "System.Drawing.Color").fromARGB cf.r cf.g cf.b
	)

-----------------------------------------------
--Progress, fill material and texture array
-----------------------------------------------
	fn doMaterialList materials = (
		startID = timeStamp()
		--reset material and texture array
		mlbxMatsAndTexs.items.clear()
		tmpArray = #()
		tmpSubArray = #()
		colMats = #()
		colMatsS = #()
		listVis = #()
		listBG = #()
		listBGType = #()
		
	--	if (mlbxMatsAndTexs.columns.count == 0 AND chkMat.checked == true) do (mlbxMatsAndTexs.columns.add "Material and Texture List" 339)

		if ( materials.count == 0 ) do (
			MessageBox "There are no materials in your current scene!" title:ProgramName
			)
			
		for h = 1 to materials.count do (
			join tmpArray  #( tmpSubArray = #( materials[h] ) )
			join tmpSubArray #( materials[h].name )
			)
			
		fn sortByXMember tmpArray1 tmpArray2 x:2 = (
			case of (
				( tmpArray1[x] < tmpArray2[x] ):-1
				( tmpArray1[x] > tmpArray2[x] ):1
				default:0
				)
			)
		qsort tmpArray sortByXMember x:2
			
		for i = 1 to tmpArray.count do (
			lblProgress.caption = ( "Material: " + tmpArray[i][1].name )
			matlists tmpArray[i][1]
			prgProgress.value = 100.000 / tmpArray.count * i
			stampID = timeStamp()
			if (((stampID - startID) / 1000.0) >= 5.00) do (
				startID = timeStamp()
				windows.processPostedMessages()
				)
			)
		lblProgress.caption = ("Done...")
		prgProgress.value = 100

		--get names from materials and textures
		for m = 1 to colMats.count do (
			if ( chkMat.checked == true AND colMats[m][3] == "mat" ) then (
				li=dotNetObject "System.Windows.Forms.ListViewItem" colMats[m][2]
				cli = ( ( colorman.getColor #background )*255+10 ) as color
				li.backColor=li.backColor.fromARGB cli.r cli.g cli.b
				append listVis li

				join listBG  #( listBGType = #( colMats[m][1] ) )
				join listBGType #( colMats[m][2] )
				join listBGType #( colMats[m][3] )
				) else if ( chkSub.checked == true AND colMats[m][3] == "sub" ) then (
					li=dotNetObject "System.Windows.Forms.ListViewItem" colMats[m][2]
					cls = ( ( colorman.getColor #background )*255+20 ) as color
					li.backColor=li.backColor.fromARGB cls.r cls.g cls.b
					append listVis li
					
					join listBG  #( listBGType = #( colMats[m][1] ) )
					join listBGType #( colMats[m][2] )
					join listBGType #( colMats[m][3] )
					) else if ( chkMap.checked == true AND colMats[m][4] == "map" ) then (
						li=dotNetObject "System.Windows.Forms.ListViewItem" colMats[m][3]
						cls = ( ( colorman.getColor #background )*255+30 ) as color
						li.backColor=li.backColor.fromARGB cls.r cls.g cls.b
						append listVis li
						
						join listBG  #( listBGType = #( colMats[m][1] ) )
						join listBGType #( colMats[m][2] )
						join listBGType #( colMats[m][3] )
						) else if ( chkTex.checked == true AND colMats[m][4] == "tex" ) then (								
							li=dotNetObject "System.Windows.Forms.ListViewItem" ("           " + colMats[m][3])
							clt = ( ( colorman.getColor #background )*255+40 ) as color
							li.backColor=li.backColor.fromARGB clt.r clt.g clt.b
							append listVis li
									
							join listBG  #( listBGType = #( colMats[m][1] ) )
							join listBGType #( colMats[m][3] )
							join listBGType #( colMats[m][4] )
							) else if ( chkmissing.checked == true AND colMats[m][4] == "tex" ) then (
								if ( colMats[m][3] == "Warning: empty bitmap texture!" ) then (
									if ( chkTex.checked == true ) then (
										li=dotNetObject "System.Windows.Forms.ListViewItem" ( "           Warning: empty bitmap texture!  " )
										clt = ( ( colorman.getColor #background )*255+40 ) as color
										li.backColor=li.backColor.fromARGB clt.r clt.g clt.b
										append listVis li
										) else (
											li=dotNetObject "System.Windows.Forms.ListViewItem" ( "           Warning: empty bitmap texture!" )
											clt = ( ( colorman.getColor #background )*255+40 ) as color
											li.backColor=li.backColor.fromARGB clt.r clt.g clt.b
											append listVis li
											)
										join listBG  #( listBGType = #( colMats[m][1] ) )
										join listBGType #( colMats[m][3] )
										join listBGType #( colMats[m][4] )
									) else if not ( doesFileExist colMats[m][1].filename ) then (
										if ( chkmissing.checked == true ) then (
										li=dotNetObject "System.Windows.Forms.ListViewItem" ( "           " + colMats[m][3] )
										clt = ( ( colorman.getColor #background )*255+30 ) as color
										li.backColor=li.backColor.fromARGB clt.r clt.g clt.b
										append listVis li
										) else (
											li=dotNetObject "System.Windows.Forms.ListViewItem" ( "           " + colMats[m][3] )
											clt = ( ( colorman.getColor #background )*255+30 ) as color
											li.backColor=li.backColor.fromARGB clt.r clt.g clt.b
											append listVis li
											)
										join listBG  #( listBGType = #( colMats[m][1] ) )
										join listBGType #( colMats[m][3] )
										join listBGType #( colMats[m][4] )
										)

								)
			)
			
			--fill the listBox mlbxMatsAndTexs box 
			mlbxMatsAndTexs.items.addRange listVis
			
			--sort array when only textures selected
			if (chkMat.checked == false AND chkSub.checked == false AND chkMap.checked == false AND chkTex.checked == false AND chkmissing == true) then (
				fn sortByXMember listBG1 listBG2 x:2 = (
					case of (
						(listBG1[x] < listBG2[x]):-1
						(listBG1[x] > listBG2[x]):1
						default:0
						)
					)
					qsort listBG sortByXMember x:2
					local sortOrder = dotNetClass "System.Windows.Forms.SortOrder"
					mlbxMatsAndTexs.Sorting = sortOrder.Ascending;
				) else if (chkMat.checked == false AND chkSub.checked == false AND chkMap.checked == false AND chkmissing == false AND chkTex.checked == true) then (
					fn sortByXMember listBG1 listBG2 x:2 = (
						case of (
							(listBG1[x] < listBG2[x]):-1
							(listBG1[x] > listBG2[x]):1
							default:0
							)
						)
					qsort listBG sortByXMember x:2
					local sortOrder = dotNetClass "System.Windows.Forms.SortOrder"
					mlbxMatsAndTexs.Sorting = sortOrder.Ascending;
					)
		)
		
-------------------------------------
--collecting material list
-------------------------------------
on btnSeMatAndTex pressed do (
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList (makeUniqueArray SelObjMats)
		) else (
			doMaterialList sceneMaterials
			)
	)

-------------------------------------
--selected list entry
-------------------------------------
on mlbxMatsAndTexs MouseClick arg do (
	selectionArray = #()
	selectionArraySub = #()
	selectionNums = #()
	
	for k = 0 to mlbxMatsAndTexs.selectedIndices.count-1 do (
		it = mlbxMatsAndTexs.selectedIndices.item[k] + 1
		join selectionArray  #(selectionArraySub = #(listBG[it][1]))
		join selectionArraySub #(listBG[it][3])
		join selectionNums #(it)
		)

		if (selectionArray.count == 1 AND selectionArray[1][2] == "tex") then (
			if (selectionArray[1][1].filename == undefined OR selectionArray[1][1].filename == "") then (
				edtMat.text = "Warning: empty bitmap texture!"
				) else (
					edtMat.text = selectionArray[1][1].filename
					)
			) else if (selectionArray.count == 1 AND selectionArray[1][2] != "tex") then (
				edtMat.text = selectionArray[1][1].name
				) else if (selectionArray.count > 1) then (
					for t = 1 to selectionArray.count do (
						if (selectionArray[t][2] == "tex") then (
							if (selectionArray[t][1].filename == undefined OR selectionArray[t][1].filename == "") then (
								messagebox "Texture file is not set, please correct this first!" title:ProgramName
								deleteItem selectionArray t
								
								mlbxMatsAndTexs.Items.item[selectionNums[t]].Selected = false
								mlbxMatsAndTexs.HideSelection = false
								exit
								) else if ( selectionArray[1][2] == "tex" ) then (
									edtMat.text = getFilenamePath selectionArray[1][1].filename
									) else (
										messagebox "Multiple selections is only for BitmapTextures allowed!" title:ProgramName
										)
							) else if (selectionArray[t][2] != "tex" ) then (
								messagebox "Multiple selections is only for BitmapTextures allowed!" title:ProgramName
								deleteItem selectionArray t

								mlbxMatsAndTexs.Items.item[selectionNums[t]].Selected = false
								mlbxMatsAndTexs.HideSelection = false 
								exit
								)
						)
					)
	)

-----------------------------------------------
--browse texture
-----------------------------------------------	
fn browseTexFile selectionArray = (
	if (selectionArray.count == 0) do (
		MessageBox "Please collect materials and maps and select a texture map first!" title:ProgramName
		return false
		)
		
	if (selectionArray.count == 1 AND superclassof selectionArray[1][1] == Material) then (
		MessageBox "Please select a texture map..." title:ProgramName
		return false
		) else if (selectionArray.count == 1 AND selectionArray[1][2] == "tex") then (
			try (filepath = getFilenamePath selectionArray[1][1].filename + filenameFromPath selectionArray[1][1].filename
				) catch (
					filepath = (getDir #renderPresets + @"\")
					)
			inputFile = getOpenFileName \
			caption:"Select Bitmap Image File" \
			filename:filepath \
			types:"All Files (*.*)|*.*|AVI File (*.avi)|*.avi|Mpeg File (*.mpg,*.mpeg)|*.mpg;*.mpeg|BMP Image File (*.bmp)|*.bmp|Kodak Cineon (*.cin)|*.cin\
				|Combustion* by Discreet (*.cws)|*.cws|OpenEXR Image File (*.exr)|*.exr|GIF Image File (*.gif)|*.gif|Radiance Image File (HDRI) (*.hdr*.pic)|*.hdr;*.pic\
				|ILF Image File (*.ifl)|*.ifl|JPEG Image File (*.jpg,*.jpe,*.jpeg)|*.jpg;*.jpe;*.jpeg|PNG Image File (*.png)|*.png|Adobe PSD Reader (*.psd)|*.psd\
				|MOV QuickTime File (*.mov)|*.mov|SGI Image File (*.rgb,*.rgba,*.sgi,*.int,*.inta,*.bw)|*.rgb;*.rgba;*.sgi;*.int;*.inta,*.bw|RLA Image File (*.rla)|*.rla\
				|RPF (*.rpf)|*.rpf|Targa Image File (*.tga)|*.tga|Tif Image File (*.tif,*.tif)|*.tif;*.tiff|YUV Image File (*.yuv)|*.yuv|DDS Image File (*.dds)|*.dds|" \
			historyCategory:"Textures"

			if (inputFile != undefined) do (
				selectionArray[1][1].filename = inputFile
				edtMat.text = inputFile
				)
			) else if ( selectionArray[1][2] == "tex" ) then (
				try (
					filepath = getFilenamePath selectionArray[1][1].filename
					folder = getSavePath caption:"Select Path:" initialDir:(filepath)
					) catch (
						MessageBox "Please change undefined texture file by file!" title:ProgramName
						)
					
				if folder != undefined do (
					inDir = getFilenamePath (folder + "/")
					for y = 1 to selectionArray.count do (
						try (selectionArray[y][1].filename = (inDir + filenameFromPath selectionArray[y][1].filename)
							edtMat.text = inDir
							) catch (
								MessageBox "Please change undefined texture file by file!" title:ProgramName
								edtMat.text = "Warning: empty bitmap texture!"
								exit
								)
						
						)
					)
				) else (
					MessageBox "Please select a texture map..." title:ProgramName
					)

		if (chkSelObj.checked == true) then (
			SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
			doMaterialList (makeUniqueArray SelObjMats)
			) else (
				doMaterialList sceneMaterials
				)
	)
	
-----------------------------------------------
--right click menu
-----------------------------------------------	
struct lv_context_menu (
	fn EditPath = (	
		browseTexFile selectionArray
		),
	fn null = (),
	fn CopyToMaterialEditor sender arg = (	
		if (selectionArray.count == 0) then (
		MessageBox "Please collect, or search, and select something first!" title:ProgramName
		) else if (selectionArray.count == 1) then (
			local meditMatch = 0
			local i

			for i = 1 to meditMaterials.count do (
				if (matchPattern (meditMaterials [i].name) pattern:selectionArray[1][1].name) do (
					activeMeditSlot = i
					MessageBox ("Material or Textures is already in Material Editor! SLOT: " + (i as string)) title:ProgramName
					meditMatch = 1
					) 
				)
			if (meditMatch == 0) do (
				setMeditMaterial sender.tag selectionArray[1][1]
				)	
			) else (
				MessageBox "Please select only one item!" title:ProgramName
				)
		),
	fn SelectObjectsByMaterial = (
		if (selectionArray.count == 1) then (
			if (selectionArray[1][2] == "mat") then (
				objArray = for obj in Geometry where obj.material != undefined AND obj.material.name == selectionArray[1][1].name collect obj
					
				-- Check if the obj is part of a group
				for obj in objArray where isGroupMember obj AND (NOT isOpenGroupMember obj) do (
					par = obj.parent
					while par != undefined do (
						if isGroupHead par then (
							setGroupOpen par true
							par = undefined
							) else (
								par = par.parent
								)
						)
					)
					select objArray
					
					for o in objArray where not(o.layer.on) do o.layer.on = true
					for o in objArray where o.layer.isFrozen do o.layer.isFrozen = false
					for o in objArray where o.isHidden do o.isHidden = false
					for o in objArray where o.isFrozen do o.isFrozen = false
					select objArray
					
				) else if (selectionArray[1][2] == "tex") then (
					messagebox "Please select a material! Your corrent selection is a texture..." title:ProgramName
					) else if (selectionArray[1][2] == "sub") then (
						messagebox "Please select a material! Your corrent selection is a subMaterial..." title:ProgramName
						) else (
							messagebox "Please select a material! Your corrent selection is a map..." title:ProgramName
							)
			) else if (selectionArray.count == 0) then (
				messagebox "No material selected..." title:ProgramName
				) else (
					messagebox "Please select a material!" title:ProgramName
					)
		),
	fn RefreshList = (
		doMaterialList sceneMaterials
		),
	fn OpenInExplorer = (
		if selectionArray.count == 1 AND selectionArray[1][2] == "tex" then (
			ShellLaunch "explorer.exe" ( getFilenamePath selectionArray[1][1].filename )
			) else (
				MessageBox "Please select one texture map..." title:ProgramName
				)
		),
	names = #( "&Edit Path","-", "&Copy To Material Editor", "&Select Objects By Material", "-", "&Refresh List", "&Open Path" ), --Asign To Object; Search Material from Selected Object
	eventHandlers = #( EditPath, null, CopyToMaterialEditor, SelectObjectsByMaterial, null, RefreshList, OpenInExplorer ),
	events = #( "Click", "Click", "Click", "Click", "Click", "Click", "Click" ),
	
	fn GetMenu = (
		cm = ( dotNetObject "System.Windows.Forms.ContextMenu" )
		for i = 1 to names.count do (
			mi = cm.MenuItems.Add names[i]
			
			if names[i] == "&Copy To Material Editor" do (
				for m = 1 to meditmaterials.count do (
					if m < 10 then (
						item = mi.menuitems.add ( "Slot:   " + m as string )
						) else (
							item = mi.menuitems.add ( "Slot: " + m as string )
							)
					item.tag = m
					dotnet.addEventHandler item events[i] eventHandlers[i]
					)
				)

			dotNet.addEventHandler  mi events[i] eventHandlers[i]
			dotNet.setLifetimeControl mi #dotnet
			)	
		cm
		)
	)
	
-------------------------------------
--mouseclick
-------------------------------------
on mlbxMatsAndTexs mouseUp sender args do (
	hit=( mlbxMatsAndTexs.HitTest ( dotNetObject "System.Drawing.Point" args.x args.y ) )
	
	if hit.item != undefined do (
		all_files=hit.item.Index
		index = mlbxMatsAndTexs.items.item[all_files].index + 1
		)

	cm = lv_context_menu()
	mlbxMatsAndTexs.ContextMenu = cm.getmenu()
	)
	
-------------------------------------
--Browse Texture button
-------------------------------------
on btnChangeTex pressed do (
	browseTexFile selectionArray
	)

-------------------------------------
--checkboxen - filter functions
-------------------------------------
on chkMat changed theState do (
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList (makeUniqueArray SelObjMats)
		) else (
			doMaterialList sceneMaterials
			)
	)

on chkSub changed theState do (
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList (makeUniqueArray SelObjMats)
		) else (
			doMaterialList sceneMaterials
			)
	)	

on chkMap changed theState do (
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList (makeUniqueArray SelObjMats)
		) else (
			doMaterialList sceneMaterials
			)
	)

on chkTex changed theState do (
	chkmissing.checked = false
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList (makeUniqueArray SelObjMats)
		) else (
			doMaterialList sceneMaterials
			)
	)

on chkmissing changed theState do (
	chkTex.checked = false
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList (makeUniqueArray SelObjMats)
		) else (
			doMaterialList sceneMaterials
			)
	)
	
on chkSelObj changed theState do (
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList (makeUniqueArray SelObjMats)
		) else (
			doMaterialList sceneMaterials
			)
	)	
-------------------------------------
--search material by name
-------------------------------------
fn searchByName intext = (
	selectionArray = #()
	selectionArraySub = #()

	if (edtBox.text != "") then (
		if (chkSelObj.checked == true) then (
			SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
			doMaterialList (makeUniqueArray SelObjMats)
			) else (
				doMaterialList sceneMaterials
				)

		--check if material or texture name exist
		local NameMatch = undefined
		local NameIndex = 1
		local NumCount = #()

		for f = 1 to listBG.count do (
			if (listBG[f][1].name == edtBox.text) then (
				NameMatch = listBG[f][1]
				NameIndex = f
				join NumCount #(f)
				) else if (listBG[f][3] == "tex" AND (try (filenameFromPath listBG[f][1].filename) catch (listBG[f][2])) == edtBox.text) then (
					NameMatch = listBG[f][1]
					NameIndex = f
					join NumCount #(f)
					)
			)

		--count textures, or materials with the same name
		if (NumCount.count > 1 AND listBG[NameIndex][3] == "tex") then (
			MessageBox ("Texture is \"" + NumCount.count as string + "\" times in use...") title:ProgramName
			for i = 1 to NumCount.count do (
				mlbxMatsAndTexs.Items.item[NumCount[i]-1].Selected = true
				mlbxMatsAndTexs.EnsureVisible[NumCount[i]-1]
				)
			mlbxMatsAndTexs.HideSelection = false
				
			for numSe in NumCount do (
				join selectionArray  #(selectionArraySub = #(listBG[numSe][1]))
				join selectionArraySub #(listBG[numSe][3])
				)
			try (edtMat.text = getFilenamePath selectionArray[1][1].filename) catch (edtMat.text = "Warning: empty bitmap texture!")
			return false
			) else if (NumCount.count > 1 AND superClassOf listBG[NameIndex][1] == Material) then (
				MessageBox ("Material is \"" + NumCount.count as string + "\" times in use!") title:ProgramName
				)

		--jump to the searched material or texture
		if (NameMatch != undefined) then (
				for g = 1 to NumCount.count do (
					mlbxMatsAndTexs.Items.item[NumCount[g]-1].Selected = true
					mlbxMatsAndTexs.EnsureVisible[NumCount[g]-1]
					)
				mlbxMatsAndTexs.HideSelection = false
			
				join selectionArray  #(selectionArraySub = #(listBG[NameIndex][1]))
				join selectionArraySub #(listBG[NameIndex][3])

				if (listBG[NameIndex][3] == "tex") then (
					try (edtMat.text = listBG[NameIndex][1].filename) catch (edtMat.text = "Warning: empty bitmap texture!")
					) else if (superClassOf listBG[NameIndex][1] == Material) then (
						edtMat.text = listBG[NameIndex][1].name
						)
			) else (
				MessageBox ("Material or map \"" + edtBox.text + "\" not found...") title:ProgramName
				)
		) else (
			MessageBox "Please type a material or map name in the text field!" title:ProgramName
			)
	)
	
--text field
-------------------------------------		
on edtBox entered input do (
	edtBox.text = input
	searchByName input
	)

--search button
-------------------------------------
on btnSeMat pressed do (
	searchByName edtBox.text
	)
	
) --rollout end

	createDialog SearchMaterialAndMaps style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing)
	cui.RegisterDialogBar SearchMaterialAndMaps minSize:[150, 100] maxSize:[-1, 1200] style:#(#cui_dock_vert, #cui_floatable, #cui_handles)
) --script end
