window.stb = {}; // Create global container

stb.createBlock = function( title, key ){
    var block = $("<div/>",{id: key, class:'fixme' });
    var title = $("<h3>").text( title )
    return block;
}

// font-awsome free..
const UP_ARROW="fas fa-arrow-alt-circle-up";
const DOWN_ARROW="fas fa-arrow-alt-circle-down";
const NO_ARROW = "fas fa-minus-circle";

/*
 choice of arrows/numbers for the table - we use various uncode blocks;
 see: https://en.wikipedia.org/wiki/Arrow_(symbol)
 Of 'arrows', only 'arrows_3' displays correctly in Windows, I think,
 arrows_1 is prettiest
*/
const ARROWS_3 = { //  see https://en.wikipedia.org/wiki/Arrow_(symbol)
'nonsig'          : '&#x25CF;',
'positive_strong' : '&#x21c8;',
'positive_med'    : '&#x2191;',
'positive_weak'   : '&#x21e1;',
'negative_strong' : '&#x21ca;',
'negative_med'    : '&#x2193;',
'negative_weak'   : '&#x21e3;'}

const ARROWS_2 = { // see https://en.wikipedia.org/wiki/Arrow_(symbol)
'nonsig'          : '',
'positive_strong' : '&#x21e7;',
'positive_med'    : '&#x2191;',
'positive_weak'   : '&#x21e3;',
'negative_strong' : '&#x21e9;',
'negative_med'    : '&#x2193;',
'negative_weak'   : '&#x21e1;'}

const ARROWS_1 = { //  see https://en.wikipedia.org/wiki/Arrow_(symbol) Don't work on Windows Unicode 9
'nonsig'          : '',
'positive_strong' : '&#x1F881;',
'positive_med'    : '&#x1F871;',
'positive_weak'   : '&#x1F861;',
'negative_strong' : '&#x1F883;',
'negative_med'    : '&#x1F873;',
'negative_weak'   : '&#x1F863;' }

const CIRCLES = {
'nonsig'          : '&#x25CF;',
'positive_strong' : '&#x25CF;',
'positive_med'    : '&#x25CF;',
'positive_weak'   : '&#x25CF;',
'negative_strong' : '&#x25CF;',
'negative_med'    : '&#x25CF;',
'negative_weak'   : '&#x25CF;' }

const MARKS =
{ 'arrows_2' : ARROWS_2,
  'arrows_1' : ARROWS_1,
  'arrows_3' : ARROWS_3,
  'circles'  : CIRCLES }

stb.propToString = function( prop ){
    if( Math.abs( prop ) < 0.01 ){
        return 'nonsig';
    } else if ( prop > 0.1 ){
        return 'positive_strong';
    } else if ( prop > 0.05 ){
        return 'positive_med';
    } else if ( prop > 0.0 ){
        return 'positive_weak';
    } else if ( prop < -0.1 ){
        return 'negative_strong';
    } else if (prop < -0.05 ){
        return 'negative_med';
    } else if ( prop < 0 ){
        return 'negative_weak';
    }
    return "wtf!!";
}

stb.getArrowAndClass = function( change, prop ){
    if( Math.abs( prop) < 0.01 ){
        return {udclass:"no-change", arrow:NO_ARROW };
    } else if( prop > 0 ){
        return {udclass:"change-up", arrow:UP_ARROW };
    } else  {
        return {udclass:"change-down",arrow:DOWN_ARROW };
    }
}

stb.createNetCost = function( result ){
    var net_cost = result.totals[2][8]/10**9;
    var view = {
        net_cost_str: "Under &#163;1bn",
        udclass: "nonsig",
        dir: ""
    }
    if( Math.abs( net_cost ) >= 1.0 ){
        if( net_cost < 0 ){
            net_cost *= -1;
            view.dir = "Less";
            view.udclass = "negative_strong";
        } else {
            view.dir = "More";
            view.udclass = "positive_strong";
        }
        view.net_cost_str = "&#163;" +"&#163;"+numeral(net_cost).format( '0,0')+"&nbsp;bn";
    }
    view.arrow = ARROWS_2[view.udclass];
    var output = Mustache.render( "<p class='{{udclass}}'> {{{net_cost_str}}} {{dir}}</strong> {{{arrow}}}</p>", view );
    $( "#net-cost" ).html( output );
}

stb.createMarginalRates = function( result ){

    var over75 = 0.0;
    var tot = 0.0;
    for( var i = 0; i < result.metr_histogram.length; i++ ){
        tot += result.metr_histogram[i];
        // FIXME brittle
        if( i >= 4){
            over75 += result.metr_histogram[i];
        }
    }

    var view = {
        av_marg_str: numeral(100.0*result.avg_metr[2]).format( '0,0')+"%",
        av_marg_change_str:numeral(100.0*result.avg_metr[3]).format( '0,0'),
        udclass: stb.propToString( result.avg_metr[3]),
        over75: numeral(100.0*over75).format( '0,0')+"%"
    }
    view.arrow = ARROWS_2[view.udclass];
    var output = Mustache.render( "<p class='{{udclass}}'> average{{{av_marg_str}}} {{{av_marg_change_str}}}</strong> {{{arrow}}} Over 75%: </p>", view );
    $( "#marginal-rates" ).html( output );
}

stb.createOneMainOutput = function( element_id, name, totals, pos, down_is_good ){
    console.log( "typeof totals " + typeof( totals ));
    console.log( "totals length" + totals.length );
    console.log( "totals " + totals.toString() );

    var nc = totals[2][pos];
    var pc = nc/totals[0][pos];
    var arrow_str = stb.propToString( pc );
    var pc_change_str = arrow_str;
    if( down_is_good ){
        pc_change_str= stb.propToString( -pc ); // point the arrow in the opposite direction
    }
    var view = {
        udclass: pc_change_str,
        arrow: ARROWS_2[arrow_str]
    }
    view.which_thing = name;
    view.net_cost_str = "&#163;"+numeral(nc/(10**9)).format( '0,0')+"&nbsp;bn";
    view.pc_cost_str = "("+numeral(pc*100).format( '0,0.0')+"%)";
    if( pc_change_str == 'nonsig'){
        view.net_cost_str = 'unchanged';
        view.pc_cost_str = '';
    }

    var output = Mustache.render( "<strong>{{{net_cost_str}}}</strong>{{{pc_cost_str}}} {{{arrow}}}</p>", view );
    $( "#"+element_id ).html( output );
}

stb.createGainLose = function( result ){
    var view = {}
    view.gainers = numeral(result.gainlose_totals.gainers).format('0,0');
    view.nc = numeral(result.gainlose_totals.nc).format('0,0');
    view.losers = numeral(result.gainlose_totals.losers).format('0,0');
    view.gainers_pct = numeral(100.0*result.gainlose_totals.gainers/result.unit_count).format('0,0.0');
    view.nc_pct = numeral(100.0*result.gainlose_totals.nc/result.unit_count).format('0,0.0');
    view.losers = numeral(100.0*result.gainlose_totals.losers/result.unit_count).format('0,0.0');
    var output = Mustache.render(
        "<ul>"+
        "<li class='negative_med''>Losers: {{losers}}({{losers_pct}}%)</li>"+
        "<li class=''>Unchanged: {{nc}}({{nc_pct}}%)</li> "+
        "<li class='positive_med'>Gainers: {{gainers}}({{gainers_pct}}%)</li>"+
        "</ul>", view );
    $( "#gainers-and-losers" ).html( output );

}

stb.createInequality = function( result ){
    var udclass = stb.propToString( result.inequality[2]['gini'] );
    var gini_post = numeral( result.inequality[1]['gini']*100 ).format( '0,0.0');
    var gini_change = numeral( result.inequality[2]['gini']*100 ).format( '0,0.0');
    var view = {
        gini_post: gini_post,
        gini_change:gini_change,
        arrow: ARROWS_2[udclass],
        udclass: udclass
    };
    if( udclass == 'nonsig'){
        view.gini_change = 'unchanged';
    }
    var output = Mustache.render( "<p class='{{udclass}}'>> {{{gini_post}}} {{{gini_change}}} {{{arrow}}}</p>", view );
    $( "#inequality" ).html( output );
    stb.createLorenzCurve( "#lorenz", result, true );
}

stb.createPoverty = function( result ){
    var udclass = stb.propToString( result.poverty[2].headcount );
    var headcount_post = numeral( 100.*result.poverty[1].headcount ).format( '0,0.0')+"%";
    var headcount_change = numeral( 100.0*result.poverty[2].headcount ).format( '0,0.0')+"%";
    var view = {
        headcount_post: headcount_post,
        headcount_change:headcount_change,
        arrow: ARROWS_2[udclass],
        udclass: udclass
    };
    if( udclass == 'nonsig'){
        view.headcount_change = '-';
    }
    var output = Mustache.render( "<p class='{{udclass}}'>{{{headcount_post}}}</strong> {{{headcount_change}}} {{{arrow}}}</p>", view );
    $( "#poverty" ).html( output );
    stb.createLorenzCurve( "#lorenz", result, true );
}

stb.createTargetting = function( result ){
    var targetted = "NA"
    if(result.targetting_total_benefits[2] > 0.0 ){
        targetted = numeral(100*result.targetting_total_benefits[2]).format('0,0.0' )+"%";
    }
    var view = {
        targetted: targetted
    };
    var output = Mustache.render( "<p>Benefit increase targetted on poor: {{targetted}} </p>", view );
    $( "#targetting" ).html( output );
}


const GOLDEN_RATIO = 1.618

stb.createLorenzCurve = function( targetId, result, thumbnail ){
    var height = 400;
    var xtitle = "Population Share";
    var ytitle = "Income Share";
    var title = "Lorenz Curve"
    if( thumbnail ){
        var height = 40;
        xtitle = "";
        ytitle = "";
        title = "";
    }
    var width = Math.trunc( GOLDEN_RATIO*height);
    var data=[];
    console.log( "deciles" + result.deciles.toString());
    console.log( "deciles[0][0] length" + result.deciles[0][0].length );
    for( var i = 0; i < result.deciles[0][0].length; i++){
        data.push( {"popn1":result.deciles[0][0][i], "pre":result.deciles[0][1][i] });
    }
    // var data_post= [];
    for( var i = 0; i < result.deciles[1][0].length; i++){
        data.push( {"popn2":result.deciles[1][0][i], "post":result.deciles[1][1][i] });
    }
    data.push( {"popn3":0.0, "base":0.0});
    data.push( {"popn3":1.0, "base":1.0});
    var gini_vg = {
        "$schema": "https://vega.github.io/schema/vega-lite/v3.json",
        "title": title,
        "width": width,
        "height": height,
        "description": title,
        "data": {"values": data }, // , "post":data_post
        "layer":[
            {
                "mark": "line",
                "encoding":{
                    "x": { "type": "quantitative",
                           "field": "popn1",
                           "axis":{
                               "title": xtitle
                           }},
                    "y": { "type": "quantitative",
                           "field": "pre",
                           "axis":{
                              "title": ytitle
                           } },
                    "color": {"value":"blue"}
                } // encoding
            }, // pre layer line
            {
                "mark": "line",
                "encoding":{
                    "x": { "type": "quantitative",
                           "field": "popn2",
                           "axis":{
                              "title": xtitle
                           }},
                    "y": { "type": "quantitative",
                           "field": "post",
                           "axis":{
                              "title": ytitle
                           } },
                   "color": {"value":"red"}
               } // encoding
           }, // post line
          { // diagonal in grey
               "mark": "line",
               "encoding":{
                   "x": { "type": "quantitative",
                          "field": "popn3" },
                   "y": { "type": "quantitative",
                          "field": "base" },
                   "color": {"value":"#ccc"},
                   "strokeWidth": {"value": 1.0}
                   // "strokeDash":
               } // encoding
           },
        ]
    }
    vegaEmbed( targetId, gini_vg );
}

stb.createDecileBarChart = function( targetId, result, thumbnail ){
    var height = 400;
    var xtitle = "Deciles";
    var ytitle = "Gains in &#163; pw";
    var title = "Gains By Decile"
    if( thumbnail ){
        var height = 40;
        xtitle = "";
        ytitle = "";
        title = "";
    }
    var width = Math.trunc( GOLDEN_RATIO*height);
    var data=[];
    console.log( "deciles" + result.deciles.toString());
    console.log( "deciles[0][2] length" + result.deciles[0][2].length );
    for( var i = 0; i < result.deciles[2][2].length; i++){
        var dec = (i+1);
        data.push( {"decile":dec, "gain":result.deciles[2][2][i] });
    }
    var deciles_vg = {
        "$schema": "https://vega.github.io/schema/vega-lite/v3.json",
        "title": title,
        "width": width,
        "height": height,
        "description": title,
        "data": {"values": data }, // , "post":data_post
        "mark": "bar",
        "encoding":{
            "x": { "type": "ordinal",
                   "field": "decile",
                   "axis":{
                      "title": xtitle
                   }
             },
            "y": { "type": "quantitative",
                   "field": "gain",
                   "axis":{
                      "title": ytitle
                   }
            }
        } // encoding
    }
    console.log( "deciles_vg=" + JSON.stringify(deciles_vg) );

    vegaEmbed( targetId, deciles_vg );
}

stb.createGainsByDecile = function( result ){
    stb.createDecileBarChart( '#deciles', result, true );
}


stb.createMainOutputs = function( result ){
    stb.createNetCost( result );
    stb.createOneMainOutput( "taxes-on-income", "Taxes on Incomes", result.totals, 0, false );
    stb.createOneMainOutput( "benefits-spending", "Spending on Benefits", result.totals, 1, false );
    stb.createOneMainOutput( "taxes-on-spending", "Taxes on Spending", result.totals, 7, false );
    stb.createInequality( result );
    stb.createGainsByDecile( result );
    stb.createGainLose( result );
    stb.createPoverty( result );
    stb.createTargetting( result );
    stb.createMarginalRates( result );
}

stb.annotationToString = function( annotation ){
    var mrs = "na";
    var tc = "na";
    if( annotation.taxcredit < 999 ){
        mrs = numeral( annotation.marginalrate*100 ).format( '0,0.0');
        tc = numeral( annotation.taxcredit ).format( '0,0.0');
    }
    return "Marginal Rate: "+mrs+"% Tax Credit: £"+tc;
}



stb.createBCOutputs = function( result ){
    var pre = result.base;
    var changed = result.changed;
    var data = [];
    var n = pre.points[1].length;
    for( var i = 0; i < n; i++){
        var annotation = "";
        if( i < (n-1)){
            annotation = stb.annotationToString(pre.annotations[i]);
        }
        data.push( {"gross1":pre.points[0][i], "pre":pre.points[1][i], "ann_pre":annotation })
    }
    // var data_post= [];
    n = changed.points[1].length;
    for( var i = 0; i < n; i++){
        var annotation = "";
        if( i < (n-1)){
            annotation = stb.annotationToString(changed.annotations[i])
        }
        data.push( {"gross2":changed.points[0][i], "post":changed.points[1][i], "ann_post":annotation })
    }

    data.push( {"gross3":0.0, "base":0.0});
    data.push( {"gross3":2000.0, "base":2000.0});
    console.log( data );

    var budget_vg = {
        "$schema": "https://vega.github.io/schema/vega-lite/v3.json",
        "title": "Budget Constraint",
        "width": 600,
        "height": 600,
        "description": "Budget Constraint",
        "data": {"values": data }, // , "post":data_post
        "layer":[
            {
                "mark": "point",
                "encoding":{
                    "x": { "type": "quantitative",
                           "field": "gross1",
                           "axis":{
                               "title": "Gross Income (£pw)"
                           }},
                    "y": { "type": "quantitative",
                           "field": "pre",
                           "axis":{
                              "title": "Net Income (£pw)"
                           } },
                    "color": {"value":"blue"}
                } // encoding
            }, // pre layer point
            {
                "mark": "point",
                "encoding":{
                    "x": { "type": "quantitative",
                           "field": "gross2",
                           "axis":{
                              "title": "Gross Income (£pw)"
                           }},
                    "y": { "type": "quantitative",
                           "field": "post",
                           "axis":{
                              "title": "Net Income (£pw)"
                           } },
                   "color": {"value":"red"}
               } // encoding
           }, // post later point
           {
                "mark": "line",
                "encoding":{
                    "x": { "type": "quantitative",
                           "field": "gross1" },
                    "y": { "type": "quantitative",
                           "field": "pre" },
                    "color": {"value":"blue"},
                    "tooltip": {"field":"ann_pre", "type":"nominal"  }
                } // encoding
            }, // pre layer line
           {
               "mark": "line",
               "encoding":{
                   "x": { "type": "quantitative",
                          "field": "gross2" },
                   "y": { "type": "quantitative",
                          "field": "post" },
                  "color": {"value":"red"},
                  "tooltip": { "field":"ann_post", "type":"nominal" }
              } // encoding
          },
          { // diagonal in grey
               "mark": "line",
               "encoding":{
                   "x": { "type": "quantitative",
                          "field": "gross3" },
                   "y": { "type": "quantitative",
                          "field": "base" },
                   "color": {"value":"#ccc"},
                   "strokeWidth": {"value": 1.0}
                   // "strokeDash":
               } // encoding
           }, // pre layer line

 // post layer line
        ]
    }
    vegaEmbed('#output', budget_vg );
}

stb.runModel = function( which_action ){
    console.log( "run model called");
    var it_allow = $("#it_allow").val();
    var it_rate_1 = $("#it_rate_1").val();
    var it_rate_2 = $("#it_rate_2").val();
    var it_band = $("#it_band").val();
    var benefit1 = $("#benefit1").val();
    var benefit2 = $("#benefit2").val();
    var ben2_l_limit = $("#ben2_l_limit").val();
    var ben2_taper = $("#ben2_taper").val();
    var ben2_u_limit = $("#ben2_u_limit").val();
    var basic_income = $("#basic_income").val();
    // $( '#output').html( "<div/>", {id:'loader'}); // a spinner
    $.ajax(
        { url: "http://oustb.mazegreenyachts.com:8000/"+which_action+"/",
         method: 'get',
         dataType: 'json',
         data: {
             it_allow: it_allow,
             it_rate_1: it_rate_1,
             it_rate_2: it_rate_2,
             it_band: it_band,
             benefit1: benefit1,
             benefit2: benefit2,
             ben2_l_limit: ben2_l_limit,
             ben2_taper: ben2_taper,
             ben2_u_limit: ben2_u_limit,
             basic_income: basic_income
         },
         success: function( result ){
             console.log( "stb; call OK");
             console.log( "result " + result );
             // var r = JSON.parse( ""+result );
             if( which_action == "stb" ){ // main model
                 stb.createMainOutputs( result );
             } else if( which_action == "bc" ){
                 stb.createBCOutputs( result ); // bc model
             } else {
                 console.log( "unknown instruction " + which_action )
             }
         }
     });
}
