//MODELS AND MATERIALS MADE BY II_PYRO_II\\
//DO NOT REUPLOAD ANYWHERE\\
//MADE FOR DANS WEAPON SHELF\\

$ModelName "dansgunshelf/dansgunshelf.mdl"

$BodyGroup "dansgunshelf"
{
	studio "reference.smd"
}

$SurfaceProp "Metal"

$Contents "solid"

$MaxEyeDeflection 90

$CDMaterials "models\dansgunshelf\"

$Sequence "idle" {
	"reference.smd"
}

$CollisionModel "physics.smd"
{
	$automass
	$inertia 1
	$damping 0
	$rotdamping 0
	$concave
}

