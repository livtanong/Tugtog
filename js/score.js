// Generated by LiveScript 1.2.0
var Score;
Score = (function(){
  Score.displayName = 'Score';
  var prototype = Score.prototype, constructor = Score;
  function Score(){}
  prototype.score = 0;
  prototype.add = function(points){
    return this.score += points;
  };
  prototype.draw = function(ctx){
    ctx.fillStyle = "white";
    ctx.textAlign = "center";
    ctx.textBaseline = "top";
    ctx.font = "48px 'Action Man'";
    return ctx.fillText(this.score, 960 / 2, 20);
  };
  return Score;
}());