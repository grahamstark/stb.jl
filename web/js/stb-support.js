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
'nonsig'          : '&#x25CF;',
'positive_strong' : '&#x21e7;',
'positive_med'    : '&#x2191;',
'positive_weak'   : '&#x21e3;',
'negative_strong' : '&#x21e9;',
'negative_med'    : '&#x2193;',
'negative_weak'   : '&#x21e1;'}

const ARROWS_1 = { //  see https://en.wikipedia.org/wiki/Arrow_(symbol) Don't work on Windows Unicode 9
'nonsig'          : '&#x25CF;',
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
        arrow: ARROWS_1[arrow_str]
    }
    view.which_thing = name;
    view.net_cost_str = "&#163;"+numeral(nc/(10**9)).format( '0,0')+"&nbsp;bn";
    view.pc_cost_str = "("+numeral(pc*100).format( '0,0.0')+"%)";
    if( pc_change_str == 'nonsig'){
        view.net_cost_str = 'unchanged';
        view.pc_cost_str = '';
    }

    var output = Mustache.render( "<p class='{{udclass}}'><strong>{{which_thing}}: {{{net_cost_str}}}</strong>{{{pc_cost_str}}} {{{arrow}}}</p>", view );
    $( "#"+element_id ).html( output );
}

stb.createInequality = function( result ){
    var udclass = stb.propToString( result.inequality[2]['gini'] );
    var view = {
        gini_post:result.inequality[1]['gini'],
        gini_change:result.inequality[2]['gini'],
        arrow: udclass,
        udclass : udclass
    };
    var output = Mustache.render( "<p class='{{udclass}}'><strong>Inequality: {{{gini_post}}}</strong> ({{{arrow}}} {{gini_change}}</p>", view );
    $( "#inequality" ).html( output );
    stb.createLorenzCurve( "#lorenz", result, true );
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
    for( var i = 0; i < result.deciles[0][0].length; i++){
        data.push( {"popn1":result.deciles[0][0][i], "pre":result.deciles[0][1][i] });
    }
    // var data_post= [];
    for( var i = 0; i < result.deciles[1][0].length; i++){
        data.push( {"popn2":result.deciles[1][0][i], "post":result.deciles[1][1][i] });
    }
    data.push( {"popn3":0.0, "base":0.0});
    data.push( {"popn3":2000.0, "base":2000.0});
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

function createDecileBarChart( result, thumbnail ){


}



stb.createMainOutputs = function( result ){
    stb.createOneMainOutput( "net-cost", "Total Costs", result.totals, 5, true );
    stb.createOneMainOutput( "taxes-on-income", "Taxes on Incomes", result.totals, 0, false );
    stb.createOneMainOutput( "benefits-spending", "Spending on Benefits", result.totals, 1, false );
    stb.createInequality( result );
}

stb.createBCOutputs = function( result ){
    var pre = result["base"];
    var changed = result["changed"];
    var data = [];
    for( var i = 0; i < pre[1].length; i++){
        data.push( {"gross1":pre[0][i], "pre":pre[1][i] })
    }
    // var data_post= [];
    for( var i = 0; i < changed[1].length; i++){
        data.push( {"gross2":changed[0][i], "post":changed[1][i] })
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
                    "color": {"value":"blue"}
                } // encoding
            }, // pre layer line
           {
               "mark": "line",
               "encoding":{
                   "x": { "type": "quantitative",
                          "field": "gross2" },
                   "y": { "type": "quantitative",
                          "field": "post" },
                  "color": {"value":"red"}
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

stb.runModel = function( page ){
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
    var which_action = $("#which_action").val();
    // $( '#output').html( "<div/>", {id:'loader'}); // a spinner
    $.ajax(
        { url: "http://oustb:8000/"+which_action+"/",
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
             if( which_action == "run" ){
                 stb.createMainOutputs( result );
             } else {
                 console.log( "base[0][1]="+result["base"][0][1] );
                 console.log( "changed[1][1]="+result["changed"][1][1] );
                 stb.createBCOutputs( result );

             }
         }
     });
}
