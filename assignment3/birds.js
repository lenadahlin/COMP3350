 
//CREATE 
   db.birds.insertMany( [
      { name: "magpie", colour:["black", "grey", "white"], size: "medium"},
      { name: "superb fairy-wren", colour:["black", "blue", "brown", "grey", "white"], size: "very small"},
      { name: "australian king-parrot", colour:["black", "blue", "green", "red"], size: "medium"},
      { name: "brolga", colour:["grey", "pink", "red"], size: "very large"},
   ] );

   db.sightings.insertMany( [
      { name: "magpie", date: "18/05/23"},
      { name: "australian king-parrot", date: "17/05/23"}
   ] );
//READ
db.birds.find( { "colour": "green" } )
//Sort by name ascending
db.birds.aggregate(
   { $sort : { name : 1 } }
 );
//JOIN
db.birds.aggregate( [
   {
     $lookup:
       {
         from: "sightings",
         localField: "name",
         foreignField: "name",
         as: "bird_sightings"
       }
  }
] )
//UPDATE
   db.birds.updateMany(
      { name: "magpie" },
      { $set: { "size" : "large" } }
   );
//DELETES
db.birds.deleteMany( { "colour" : "pink" } );
db.birds.deleteMany({})

