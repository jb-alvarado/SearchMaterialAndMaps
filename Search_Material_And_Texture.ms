/*
----------------------------------------------------------------------------------------------------------------------
::
::    Description: This MaxScript is for collecting materials and texture, searching by name, 
::		    modify the texture path and copy the selection in the material editor.
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
:: This is version 0.75 from 2013-06-04. Last bigger modification was on 2013-06-01
:: 2013-05-27: build the script
:: 2013-06-01: rewrite and optimize the code (Jonathan Baecker)
:: 2013-06-02: Add support for multiple texture selections (Jonathan Baecker)
:: 2013-06-04: Add list filter options (Jonathan Baecker)
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
fn GetBitmapTextures mtl =
	(
		local texFiles= #()
		
		join texFiles (getClassInstances bitmapTexture target:mtl asTrackViewPick:off)
	
		for texFile in texFiles do (
			join colMats  #(colMatsS = #(texFile))
			join colMatsS #("        " + getFilenameFile texFile.filename + getFilenameType texFile.filename)
			join colMatsS #("tex")
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

rollout SearchMaterialAndTextures "Search Materials And Textures" width:400 height:660 (
	
		local ProgramName = "Search Material and Textures"
		local listVis = #()
		local listBG = #()
		local selTexArray = #()
		local selTexNums = #()
		local edtBoxText = ""

	groupBox grpProgress "Progress:" pos:[10,10] width:380 height:60
		label lblProgress "" pos:[20,30] width:200 height:16
		progressBar prgProgress "" pos:[20,49] width:360 height:12 color:[0,200,0]
	
	groupBox grpSeMyTex "Collection From All Materials And Textures:" pos:[10,75] width:380 height:495
		button btnSeMatAndTex "Collect Materials and Textures" pos:[20,95] width:160 height:20
		editText edtMat "" pos:[16,122] width:300 readOnly:true
		button btnChangeTex "Browse" pos:[320,122] width:60 height:18
		multiListBox mlbxMatsAndTexs "" pos:[20,145] width:360 height:30
		checkBox chkMat "Show Materials" pos:[20,547] checked:true
		checkBox chkSub "Show SubMaterials" pos:[145,547] checked:true
		checkBox chkTex "Show Textures" pos:[290,547] checked:true
	
	groupBox grpSeByName "Search Material And Textures By Name:" pos:[10,575] width:380 height:75
		editText edtBox text:"" pos:[16,593] width:304
		button btnSeMat "Search" pos:[330,593] width:50 height:20
		spinner spnSlotNum "Material Editor, Slot Number: " pos:[265,623] width:55 height:16 range:[1,24,1] type:#integer
		button btnMoveMat "Copy To" pos:[330,621] width:50 height:20	
	
	-----------------------------------------------
	--resize statment
	-----------------------------------------------
	on SearchMaterialAndTextures resized newSize do (
		
		grpProgress.width=newSize[1]-20
		
		grpSeMyTex.width=newSize[1]-20
		grpSeMyTex.height=newSize[2]-165
			edtMat.width=newSize[1]-105
			btnChangeTex.pos=[newSize[1]-80,122] 
			mlbxMatsAndTexs.width=newSize[1]-40
			mlbxMatsAndTexs.height=newSize[2]-264
			chkMat.pos=[20,newSize[2]-113]
			chkSub.pos=[newSize[1]/2-55,newSize[2]-113]
			chkTex.pos=[newSize[1]-110,newSize[2]-113]
		
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
	fn doMaterialList sceneMaterials = (
			--reset material and texture array
			colMats = #()
			colMatsS = #()
			listVis = #()
			listBG = #()		
			
			if (sceneMaterials.count == 0) do
				(
					MessageBox "There are no materials in your current scene!" title:ProgramName 
				)				
								
			for i = 1 to sceneMaterials.count do 
				(
					lblProgress.caption = ("Material: " + sceneMaterials[i].name)
					matScene = sceneMaterials[i].name
					matlists sceneMaterials[i]
					prgProgress.value = 100.000 / sceneMaterials.count * i
				)
				
			lblProgress.caption = ("Done...")	
			prgProgress.value = 100
			
	--get names from materials and textures
		for m = 1 to colMats.count do (
			if (chkMat.checked == true AND colMats[m][3] == "mat") then (
				join listVis #(colMats[m][2])
				join listBG #(colMats[m][1])
				) else if (chkSub.checked == true AND colMats[m][3] == "sub") then (
					join listVis #(colMats[m][2])
					join listBG #(colMats[m][1])
					) else if (chkTex.checked == true AND colMats[m][3] == "tex") then (
						join listVis #(colMats[m][2])
						join listBG #(colMats[m][1])
						)
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
		doMaterialList sceneMaterials
	)	
	
-------------------------------------
--selected list entry
-------------------------------------	
on mlbxMatsAndTexs selectionEnd do (
	selTexArray = #()
	selTexNums = #()
	for k in mlbxMatsAndTexs.selection do (
		join selTexArray #(listBG[k])
		join selTexNums #(k)
		)
		
		if (selTexArray.count == 1 AND classof selTexArray[1] == BitmapTexture) then (
			edtMat.text = getFilenamePath selTexArray[1].filename + getFilenameFile selTexArray[1].filename + getFilenameType selTexArray[1].filename
			) else if (selTexArray.count == 1 AND superclassof selTexArray[1] == Material) then (
				edtMat.text = selTexArray[1].name
				) else if (selTexArray.count > 1) then (
					for t = 1 to selTexArray.count do (
						if (classof selTexArray[t] == BitmapTexture) then (
							edtMat.text = getFilenamePath  selTexArray[1].filename
							) else if (superclassof selTexArray[t] == Material ) then (
								messagebox "Multiple selections is only for BitmapTextures allowed!" title:ProgramName 
								deleteItem selTexArray t
								deleteItem selTexNums t
								mlbxMatsAndTexs.selection = selTexNums
								exit
								)
						)
					)
	)
-------------------------------------
--Browse Texture
-------------------------------------	
on btnChangeTex pressed do ( 
	if (selTexArray.count == 0) do (
		MessageBox "Please collect materials and textures first!" title:ProgramName
		return false
		)
		
	if (selTexArray.count == 1 AND superclassof selTexArray[1] == Material) then (
		MessageBox "Please select a texture map..." title:ProgramName
		return false
		) else if (selTexArray.count == 1 AND classof selTexArray[1] == BitmapTexture) then (
			filepath = getFilenamePath selTexArray[1].filename + getFilenameFile selTexArray[1].filename + getFilenameType selTexArray[1].filename

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
				selTexArray[1].filename = inputFile
				edtMat.text = inputFile
				)	
			) else (
				filepath = getFilenamePath selTexArray[1].filename
				
				folder = getSavePath caption:"Select Path:" initialDir:(filepath)
				if folder != undefined do (
					inDir = getFilenamePath (folder + "/")
					for y = 1 to selTexArray.count do (
						selTexArray[y].filename = (inDir + getFilenameFile selTexArray[y].filename + getFilenameType selTexArray[y].filename)
						edtMat.text = inDir
						)
					)
				)
		
		doMaterialList sceneMaterials
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
	selTexArray = #()
	doMaterialList sceneMaterials
	
	if (edtBox.text != "") then (
		matLS = #()
		local i
		
		for i = 1 to meditMaterials.count do 
		(					
			join matLS #(meditMaterials [i].name)	
		)
		
		--check if material or texture name exist
		local NameMatch = undefined
		local NameIndex = 1
		local NumCount = #()
		
		for f = 1 to listBG.count do (
			if (listBG[f].name == edtBox.text) then (
				NameMatch = listBG[f]
				NameIndex = f
				join NumCount #(f)
				) else if (classof listBG[f] == BitmapTexture AND (getFilenameFile listBG[f].filename + getFilenameType listBG[f].filename) == edtBox.text) then (
					NameMatch = listBG[f]
					NameIndex = f
				
					join NumCount #(f)
					)
			)
			
		--count textures, or materials with the same name	
		if (NumCount.count > 1 AND classOf listBG[NameIndex] == BitmapTexture) then (
			MessageBox ("Texture is \"" + NumCount.count as string + "\" times in use...") title:ProgramName
			mlbxMatsAndTexs.selection=NumCount
			
			for numSe in NumCount do (
				join selTexArray #(listBG[numSe])
				)
				edtMat.text = getFilenamePath selTexArray[1].filename
				return false
				
			) else if (NumCount.count > 1 AND superClassOf listBG[NameIndex] == Material) then (
				MessageBox ("Material is \"" + NumCount.count as string + "\" times in use! Selecting last...") title:ProgramName
				)
		
		--jump to the searched material or texture	
		if (NameMatch != undefined) then (
				mlbxMatsAndTexs.selection = NameIndex
				join selTexArray #(listBG[NameIndex])
				if (classof listBG[NameIndex] == BitmapTexture) then (
					edtMat.text = getFilenamePath listBG[NameIndex].filename + getFilenameFile listBG[NameIndex].filename + getFilenameType listBG[NameIndex].filename
					) else if (superClassOf listBG[NameIndex] == Material) then (
						edtMat.text = listBG[NameIndex].name
						)
			) else (
				MessageBox ("Material or Textures \"" + edtBox.text + "\" not found...") title:ProgramName
				)		
		) else ( 
			MessageBox "Please type a material name in the text field!" title:ProgramName
			)
	) --btnSeMat end
	
-------------------------------------
--copy texture to material editor
-------------------------------------		
on btnMoveMat pressed do (
	if (selTexArray.count == 0) then (
		MessageBox "Please collect, or search, and select something first!" title:ProgramName
		) else if (selTexArray.count == 1) then (
			matLS = #()
			local i
			
			for i = 1 to meditMaterials.count do (					
				join matLS #(meditMaterials [i].name)	
				)
			
			if (findItem matLS selTexArray[1].name > 0) then (
				activeMeditSlot = (findItem matLS selTexArray[1].name) 
				MessageBox ("Material or Textures is already in Material Editor! SLOT: " + (findItem matLS selTexArray[1].name) as string) title:ProgramName
				) else (
					setMeditMaterial spnSlotNum.value selTexArray[1]
					)
			) else (
				MessageBox "Please select only one item!" title:ProgramName
				)
	)	
	
) --rollout end


try ( destroyDialog SearchMaterialAndTextures )
	catch (	MessageBox "Dialog not found!" )

	createDialog SearchMaterialAndTextures style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox, #style_resizing)
) --script end
