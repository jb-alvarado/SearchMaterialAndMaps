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
:: This is version 0.95 from 2013-06-09. Last bigger modification was on 2013-06-01
:: 2013-05-27: build the script
:: 2013-06-01: rewrite and optimize the code (Jonathan Baecker)
:: 2013-06-02: Add support for multiple texture selections (Jonathan Baecker)
:: 2013-06-04: Add list filter options, and select object by material (Jonathan Baecker)
:: 2013-06-05: Add missing texture filter and small changes (Jonathan Baecker)
:: 2013-06-06: Optimize the search command and add a sort function for the texture list (Jonathan Baecker)
:: 2013-06-07: Add a sort function for the material list (Jonathan Baecker)
:: 2013-06-09: Add show texture slot checkbox and show material and texture from selected objects (Jonathan Baecker)
::
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
--
--  Script Name: Search Materials And Textures
--
--	Author:   Jonathan Baecker (jb_alvardo), www.pixelcrusher.de | blog.pixelcrusher.de
--
----------------------------------------------------------------------------------------------------------------------
*/

(
	global colMats = #()
	global colMatsS = #()
	
-------------------------------------------------------------------
--Search texture by name function
-------------------------------------------------------------------
fn GetBitmapTextures mtl = (
	local texFiles= #()
	local texFilesSub= #()
	local tmp = #()
	local tmpsub = #()
	for a = 1 to (getNumSubTexmaps mtl) do (
		if ((getSubTexmap mtl a) != undefined) do (
			join texFiles #(texFilesSub= #((getClassInstances bitmapTexture target:(getSubTexmap mtl a) asTrackViewPick:off)))
			join texFilesSub #("[" + getSubTexmapSlotName mtl a + "]")
			)
		)
		
		for b = 1 to texFiles.count do (
			for c = 1 to texFiles[b][1].count do (
				join colMats #(colMatsS= #(texFiles[b][1][c]))
				join colMatsS #(texFiles[b][2])
				join colMatsS #(filenameFromPath texFiles[b][1][c].filename)
				join colMatsS #("tex")
				)	
			) 
	)


-------------------------------------------------------------------
--Search material by name function
-------------------------------------------------------------------
fn matlists mtl = (
		case classof mtl of (
			--------------------------------------------------
			--Blend
			--------------------------------------------------
			Blend:
			(
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
				join colMatsS #("mat")

				local blendMat = #()

				if (mtl.map1 != undefined) do (
					join colMats  #(colMatsS = #(mtl.map1))
					join colMatsS #("    " + mtl.map1.name)
					join colMatsS #("sub")

					GetBitmapTextures mtl.map1
					)
				if (mtl.map2 != undefined) do (
					join colMats  #(colMatsS = #(mtl.map2))
					join colMatsS #("    " + mtl.map2.name)
					join colMatsS #("sub")
						
					GetBitmapTextures mtl.map2
					)
			)
			--------------------------------------------------
			--Shellac
			--------------------------------------------------
			Shellac:
			(
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
				join colMatsS #("mat")

				if (mtl.shellacMtl1 != undefined) do (
					join colMats  #(colMatsS = #(mtl.shellacMtl1))
					join colMatsS #("    " + mtl.shellacMtl1.name)
					join colMatsS #("sub")

					GetBitmapTextures mtl.shellacMtl1
					)
				if (mtl.shellacMtl2 != undefined) do (
					join colMats  #(colMatsS = #(mtl.shellacMtl2))
					join colMatsS #("    " + mtl.shellacMtl2.name)
					join colMatsS #("sub")

					GetBitmapTextures mtl.shellacMtl2
					)
			)
			--------------------------------------------------
			--TopBottom 
			--------------------------------------------------
			TopBottom:
			(
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
				join colMatsS #("mat")

				if (mtl.topMaterial != undefined) do (
					join colMats  #(colMatsS = #(mtl.topMaterial))
					join colMatsS #("    " + mtl.topMaterial.name)
					join colMatsS #("sub")	

					GetBitmapTextures mtl.topMaterial
					)
				if (mtl.bottomMaterial != undefined) do (
					join colMats  #(colMatsS = #(mtl.bottomMaterial))
					join colMatsS #("    " + mtl.bottomMaterial.name)
					join colMatsS #("sub")

					GetBitmapTextures mtl.bottomMaterial
					)
			)
			--------------------------------------------------
			--DoubleSided 
			--------------------------------------------------
			doubleSided:
			(
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
				join colMatsS #("mat")

				if (mtl.material1 != undefined) do (
					join colMats  #(colMatsS = #(mtl.material1))
					join colMatsS #("    " + mtl.material1.name)
					join colMatsS #("sub")

					GetBitmapTextures mtl.material1
					)
				if (mtl.material2 != undefined) do (
					join colMats  #(colMatsS = #(mtl.material2))
					join colMatsS #("    " + mtl.material2.name)
					join colMatsS #("sub")

					GetBitmapTextures mtl.material2	
					)
			)
			--------------------------------------------------
			--Shell_Material 
			--------------------------------------------------
			Shell_Material:
			(
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
				join colMatsS #("mat")

				if (mtl.originalMaterial != undefined) do (
					join colMats  #(colMatsS = #(mtl.originalMaterial))
					join colMatsS #("    " + mtl.originalMaterial.name)
					join colMatsS #("sub")

					GetBitmapTextures mtl.originalMaterial
					)
				if (mtl.bakedMaterial != undefined) do (
					join colMats  #(colMatsS = #(mtl.bakedMaterial))
					join colMatsS #("    " + mtl.bakedMaterial.name)
					join colMatsS #("sub")

					GetBitmapTextures mtl.bakedMaterial
					)
			)
			--------------------------------------------------
			-- Multimaterials
			--------------------------------------------------
			MultiMaterial:
			(
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
				join colMatsS #("mat")

				local m
				for m = 1 to mtl.numsubs do
				(
					if (mtl[m] != undefined) do (
						join colMats  #(colMatsS = #(mtl[m]))
						join colMatsS #("    " + mtl[m].name)
						join colMatsS #("sub")

						GetBitmapTextures mtl[m]
						)
				)
		 	)
			--------------------------------------------------
			--CompositeMaterial
			--------------------------------------------------
			CompositeMaterial:
			(
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
				join colMatsS #("mat")

				local c
				for c = 1 to mtl.materialList.count do
				(
					if (mtl.materialList[c] != undefined) do (
						join colMats  #(colMatsS = #(mtl.materialList[c]))
						join colMatsS #("    " + mtl.materialList[c].name)
						join colMatsS #("sub")

						GetBitmapTextures mtl.materialList[c]
						)
				)
		 	)
			--------------------------------------------------
			--all other materials
			--------------------------------------------------
			default:
			(
				if (superclassof mtl == material) do (
					join colMats  #(colMatsS = #(mtl))
					join colMatsS #(mtl.name)
					join colMatsS #("mat")

					GetBitmapTextures mtl
					)
			)
			
		) --case end
		
	) --fn matlists end

rollout SearchMaterialAndTextures "Search Materials And Textures" width:400 height:680 (
	
		local ProgramName = "Search Material and Textures"
		local listVis = #()
		local listBG = #()
		local selectionArray = #()
		local selectionNums = #()
		local edtBoxText = ""

	groupBox grpProgress "Progress:" pos:[10,10] width:380 height:60
		label lblProgress "" pos:[20,30] width:200 height:16
		progressBar prgProgress "" pos:[20,49] width:360 height:12 color:[0,200,0]

	groupBox grpSeMyTex "Collection From All Materials And Textures:" pos:[10,75] width:380 height:515
		button btnSeMatAndTex "Collect Materials and Textures" pos:[20,95] width:160 height:20
		button btnSelObj "Select Objects By Material" pos:[240,95] width:140 height:20
		editText edtMat "" pos:[16,122] width:300 readOnly:true
		button btnChangeTex "Browse" pos:[320,122] width:60 height:18
		multiListBox mlbxMatsAndTexs "" pos:[20,145] width:360 height:30
		checkBox chkMat "Show Materials" pos:[20,547] checked:true
		checkBox chkSub "Show SubMaterials" pos:[145,547] checked:true
		checkBox chkTex "Show Textures" pos:[290,547] checked:true
		checkBox chkmissing "Missing Texture Path" pos:[20,567] checked:false
		checkBox chkTexSlot "Show Texture Slot" pos:[145,567] checked:false
		checkBox chkSelObj "From Selection" pos:[290,567] checked:false

	groupBox grpSeByName "Search Material And Textures By Name:" pos:[10,595] width:380 height:75
		editText edtBox text:"" pos:[16,613] width:304
		button btnSeMat "Search" pos:[330,613] width:50 height:20
		spinner spnSlotNum "Material Editor, Slot Number: " pos:[265,643] width:55 height:16 range:[1,24,1] type:#integer
		button btnMoveMat "Copy To" pos:[330,641] width:50 height:20

	-----------------------------------------------
	--resize statment
	-----------------------------------------------
	on SearchMaterialAndTextures resized newSize do (

		grpProgress.width=newSize[1]-20

		grpSeMyTex.width=newSize[1]-20
		grpSeMyTex.height=newSize[2]-165
			btnSelObj.pos=[newSize[1]-160,95]
			edtMat.width=newSize[1]-105
			btnChangeTex.pos=[newSize[1]-80,122] 
			mlbxMatsAndTexs.width=newSize[1]-40
			mlbxMatsAndTexs.height=newSize[2]-284
			chkMat.pos=[20,newSize[2]-133]
			chkSub.pos=[newSize[1]/2-55,newSize[2]-133]
			chkTex.pos=[newSize[1]-110,newSize[2]-133]
			chkmissing.pos=[20,newSize[2]-113]
			chkTexSlot.pos=[newSize[1]/2-55,newSize[2]-113]
			chkSelObj.pos=[newSize[1]-110,newSize[2]-113]

		grpSeByName.width=newSize[1]-20
		grpSeByName.pos=[10, newSize[2]-85]
			edtBox.width=newSize[1]-100
			edtBox.pos=[20,newSize[2]-67]
			btnSeMat.pos=[newSize[1]-70,newSize[2]-67]
			spnSlotNum.pos=[newSize[1]-91,newSize[2]-37]
			btnMoveMat.pos=[newSize[1]-70,newSize[2]-39]
		)

-----------------------------------------------
--Progress, fill material and texture array
-----------------------------------------------
	fn doMaterialList materials = (
		--reset material and texture array
		tmpArray = #()
		tmpSubArray = #()
		colMats = #()
		colMatsS = #()
		listVis = #()
		listBG = #()
		listBGType = #()

		if (materials.count == 0) do (
			MessageBox "There are no materials in your current scene!" title:ProgramName
			)
			
		for h = 1 to materials.count do (
			join tmpArray  #(tmpSubArray = #(materials[h]))
			join tmpSubArray #(materials[h].name)
			)
			
		fn sortByXMember tmpArray1 tmpArray2 x:2 = (
			case of (
				(tmpArray1[x] < tmpArray2[x]):-1
				(tmpArray1[x] > tmpArray2[x]):1
				default:0
				)
			)
		qsort tmpArray sortByXMember x:2
			
		for i = 1 to tmpArray.count do (
			lblProgress.caption = ("Material: " + tmpArray[i][1].name)
			matlists tmpArray[i][1]
			prgProgress.value = 100.000 / tmpArray.count * i
			)
		lblProgress.caption = ("Done...")
		prgProgress.value = 100

		--get names from materials and textures
		for m = 1 to colMats.count do (
			if (chkMat.checked == true AND colMats[m][3] == "mat") then (
				join listVis #(colMats[m][2])
				join listBG  #(listBGType = #(colMats[m][1]))
				join listBGType #(colMats[m][2])
				join listBGType #(colMats[m][3])
				) else if (chkSub.checked == true AND colMats[m][3] == "sub") then (
					join listVis #(colMats[m][2])
					join listBG  #(listBGType = #(colMats[m][1]))
					join listBGType #(colMats[m][2])
					join listBGType #(colMats[m][3])
						) else if (chkTex.checked == true AND colMats[m][4] == "tex") then (
							if (chkTexSlot.checked == true) then (
								join listVis #("        " + colMats[m][3] + "  " + colMats[m][2])
								) else (
									join listVis #("        " + colMats[m][3])
									)
							join listBG  #(listBGType = #(colMats[m][1]))
							join listBGType #(colMats[m][3])
							join listBGType #(colMats[m][4])
							) else if (chkmissing.checked == true AND colMats[m][4] == "tex") then (
								if not (doesFileExist colMats[m][1].filename) do (
									if (chkTexSlot.checked == true) then (
										join listVis #("        " + colMats[m][3] + "  " + colMats[m][2])
										) else (
											join listVis #("        " + colMats[m][3])
											)
									join listBG  #(listBGType = #(colMats[m][1]))
									join listBGType #(colMats[m][3])
									join listBGType #(colMats[m][4])
									)
								)
			)
			
			--sort array when only textures selected
			if (chkMat.checked == false AND chkSub.checked == false AND chkTex.checked == true AND chkmissing.checked == false) then (
				fn sortByXMember listBG1 listBG2 x:2 = (
					case of (
						(listBG1[x] < listBG2[x]):-1
						(listBG1[x] > listBG2[x]):1
						default:0
						)
					)
					qsort listBG sortByXMember x:2
					sort listVis
				) else if (chkMat.checked == false AND chkSub.checked == false AND chkTex.checked == false AND chkmissing.checked == true) then (
					fn sortByXMember listBG1 listBG2 x:2 = (
						case of (
							(listBG1[x] < listBG2[x]):-1
							(listBG1[x] > listBG2[x]):1
							default:0
							)
						)
					qsort listBG sortByXMember x:2
					sort listVis
					)
					
			--fill the listBox mlbxMatsAndTexs box 
			mlbxMatsAndTexs.items = listVis
		)

-------------------------------------
	--Buttons
-------------------------------------
--collecting material list
-------------------------------------
on btnSeMatAndTex pressed do (
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList SelObjMats
		) else (
			doMaterialList sceneMaterials
			)
	)	

-------------------------------------
--select objects by material
-------------------------------------
on btnSelObj pressed do (
	if (selectionArray.count == 1) then (
		if (selectionArray[1][2] == "mat") then (
			select (for obj in Geometry where obj.material != undefined AND obj.material.name == selectionArray[1][1].name collect obj)
			) else if (selectionArray[1][2] == "tex") then (
				messagebox "Please select a material! Your corrent selection is a texture..." title:ProgramName
				) else if (selectionArray[1][2] == "sub") then (
					messagebox "Please select a material! Your corrent selection is a subMaterial..." title:ProgramName
					)
		) else if (selectionArray.count == 0) then (
			messagebox "No material selected..." title:ProgramName
			) else (
				messagebox "Please select a material!" title:ProgramName
				)
	)

-------------------------------------
--selected list entry
-------------------------------------
on mlbxMatsAndTexs selectionEnd do (
	selectionArray = #()
	selectionArraySub = #()
	selectionNums = #()
	for k in mlbxMatsAndTexs.selection do (
		join selectionArray  #(selectionArraySub = #(listBG[k][1]))
		join selectionArraySub #(listBG[k][3])
		join selectionNums #(k)
		)

		if (selectionArray.count == 1 AND selectionArray[1][2] == "tex") then (
			edtMat.text = getFilenamePath selectionArray[1][1].filename + filenameFromPath selectionArray[1][1].filename
			) else if (selectionArray.count == 1 AND superclassof selectionArray[1][1] == Material) then (
				edtMat.text = selectionArray[1][1].name
				) else if (selectionArray.count > 1) then (
					for t = 1 to selectionArray.count do (
						if (selectionArray[t][2] == "tex") then (
							edtMat.text = getFilenamePath selectionArray[1][1].filename
							) else if (superclassof selectionArray[t][1] == Material ) then (
								messagebox "Multiple selections is only for BitmapTextures allowed!" title:ProgramName
								deleteItem selectionArray t
								deleteItem selectionNums t
								mlbxMatsAndTexs.selection = selectionNums
								exit
								)
						)
					)
	)
-------------------------------------
--Browse Texture
-------------------------------------
on btnChangeTex pressed do (
	if (selectionArray.count == 0) do (
		MessageBox "Please collect materials and textures first!" title:ProgramName
		return false
		)
		
	if (selectionArray.count == 1 AND superclassof selectionArray[1][1] == Material) then (
		MessageBox "Please select a texture map..." title:ProgramName
		return false
		) else if (selectionArray.count == 1 AND selectionArray[1][2] == "tex") then (
			filepath = getFilenamePath selectionArray[1][1].filename + filenameFromPath selectionArray[1][1].filename

			inputFile = getOpenFileName \
			caption:"Select Bitmap Image File" \
			filename:filepath \
			types:"All Files (*.*)|*.*|AVI File (*.avi)|*.avi|Mpeg File (*.mpg,*.mpeg)|*.mpg;*.mpeg|BMP Image File (*.bmp)|*.bmp|Kodak Cineon (*.cin)|*.cin|Combustion* by Discreet (*.cws)|*.cws\
			|OpenEXR Image File (*.exr)|*.exr|GIF Image File (*.gif)|*.gif|Radiance Image File (HDRI) (*.hdr*.pic)|*.hdr;*.pic|ILF Image File (*.ifl)|*.ifl\
			|JPEG Image File (*.jpg,*.jpe,*.jpeg)|*.jpg;*.jpe;*.jpeg|PNG Image File (*.png)|*.png|Adobe PSD Reader (*.psd)|*.psd|MOV QuickTime File (*.mov)|*.mov\
			|SGI Image File (*.rgb,*.rgba,*.sgi,*.int,*.inta,*.bw)|*.rgb;*.rgba;*.sgi;*.int;*.inta,*.bw|RLA Image File (*.rla)|*.rla|RPF (*.rpf)|*.rpf|Targa Image File (*.tga)|*.tga|Tif Image File (*.tif,*.tif)|*.tif;*.tiff\
			|YUV Image File (*.yuv)|*.yuv|DDS Image File (*.dds)|*.dds|" \
			historyCategory:"Textures"

			if (inputFile != undefined) do (
				selectionArray[1][1].filename = inputFile
				edtMat.text = inputFile
				)
			) else (
				filepath = getFilenamePath selectionArray[1][1].filename

				folder = getSavePath caption:"Select Path:" initialDir:(filepath)
				if folder != undefined do (
					inDir = getFilenamePath (folder + "/")
					for y = 1 to selectionArray.count do (
						selectionArray[y][1].filename = (inDir + filenameFromPath selectionArray[y][1].filename)
						edtMat.text = inDir
						)
					)
				)

		if (chkSelObj.checked == true) then (
			SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
			doMaterialList SelObjMats
			) else (
				doMaterialList sceneMaterials
				)
		)

-------------------------------------
--checkboxen - filter functions
-------------------------------------
on chkMat changed theState do (
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList SelObjMats
		) else (
			doMaterialList sceneMaterials
			)
	)

on chkSub changed theState do (
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList SelObjMats
		) else (
			doMaterialList sceneMaterials
			)
	)	

on chkTex changed theState do (
	chkmissing.checked = false
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList SelObjMats
		) else (
			doMaterialList sceneMaterials
			)
	)

on chkmissing changed theState do (
	chkTex.checked = false
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList SelObjMats
		) else (
			doMaterialList sceneMaterials
			)
	)

on chkTexSlot changed theState do (
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList SelObjMats
		) else (
			doMaterialList sceneMaterials
			)
	)
	
on chkSelObj changed theState do (
	if (chkSelObj.checked == true) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList SelObjMats
		) else (
			doMaterialList sceneMaterials
			)
	)	
-------------------------------------
--search material by name
-------------------------------------

--text field (funtion not really need at the moment)
-------------------------------------		
on edtBox changed text do (
	edtBoxText = edtBox.text 
	)

on edtBox entered text do (
	edtBox.text = edtBoxText
	setfocus SearchMaterialAndTextures
	)

--search button
-------------------------------------
on btnSeMat pressed do (
	selectionArray = #()
	selectionArraySub = #()

	if (edtBox.text != "") then (
		if (chkSelObj.checked == true) then (
			SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
			doMaterialList SelObjMats
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
				) else if (listBG[f][3] == "tex" AND (filenameFromPath listBG[f][1].filename) == edtBox.text) then (
					NameMatch = listBG[f][1]
					NameIndex = f
					join NumCount #(f)
					)
			)

		--count textures, or materials with the same name
		if (NumCount.count > 1 AND listBG[NameIndex][3] == "tex") then (
			MessageBox ("Texture is \"" + NumCount.count as string + "\" times in use...") title:ProgramName
			mlbxMatsAndTexs.selection=NumCount

			for numSe in NumCount do (
				join selectionArray  #(selectionArraySub = #(listBG[numSe][1]))
				join selectionArraySub #(listBG[numSe][3])
				)
			edtMat.text = getFilenamePath selectionArray[1][1].filename
			return false
			) else if (NumCount.count > 1 AND superClassOf listBG[NameIndex][1] == Material) then (
				MessageBox ("Material is \"" + NumCount.count as string + "\" times in use! Selecting last...") title:ProgramName
				)

		--jump to the searched material or texture
		if (NameMatch != undefined) then (
				mlbxMatsAndTexs.selection = NameIndex
				join selectionArray  #(selectionArraySub = #(listBG[NameIndex][1]))
				join selectionArraySub #(listBG[NameIndex][3])

				if (listBG[NameIndex][3] == "tex") then (
					edtMat.text = getFilenamePath listBG[NameIndex][1].filename + filenameFromPath listBG[NameIndex][1].filename
					) else if (superClassOf listBG[NameIndex][1] == Material) then (
						edtMat.text = listBG[NameIndex][1].name
						)
			) else (
				MessageBox ("Material or Textures \"" + edtBox.text + "\" not found...") title:ProgramName
				)
		) else (
			MessageBox "Please type a material or texture name in the text field!" title:ProgramName
			)
	) --btnSeMat end

-------------------------------------
--copy texture to material editor
-------------------------------------
on btnMoveMat pressed do (
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
				setMeditMaterial spnSlotNum.value selectionArray[1][1]
				)	
			) else (
				MessageBox "Please select only one item!" title:ProgramName
				)
	) --btnMoveMat end

) --rollout end


try ( destroyDialog SearchMaterialAndTextures )
	catch (	MessageBox "Dialog not found!" )

	createDialog SearchMaterialAndTextures style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox, #style_resizing)
) --script end
