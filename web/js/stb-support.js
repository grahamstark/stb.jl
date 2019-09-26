window.stb = {}; // Create global container

stb.createMainOutputs = function( result ){


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
    console.log( data );

    var budget_vg = {
        "$schema": "https://vega.github.io/schema/vega-lite/v3.json",
        "width": 300,
        "height": 300,
        "description": "Budget Constraint",
        "data": {"values": data }, // , "post":data_post
        "layer":[
            {
                "mark": "point",
                "encoding":{
                    "x": { "type": "quantitative",
                           "field": "gross1",
                           "axis":{
                               "title": "Gross Income"
                           }},
                    "y": { "type": "quantitative",
                           "field": "pre",
                           "axis":{
                              "title": "Net Income"
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
                              "title": "Gross Income"
                           }},
                    "y": { "type": "quantitative",
                           "field": "post",
                           "axis":{
                              "title": "Net Income"
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
            } // post layer line
        ]
    }
    vegaEmbed('#output', budget_vg );
}

stb.runModel = function( page ){
    console.log( "run model called")
    var it_allow = $("#it_allow").val()
    var it_rate_1 = $("#it_rate_1").val()
    var it_rate_2 = $("#it_rate_2").val()
    var it_band = $("#it_band").val()
    var benefit1 = $("#benefit1").val()
    var benefit2 = $("#benefit2").val()
    var ben2_l_limit = $("#ben2_l_limit").val()
    var ben2_taper = $("#ben2_taper").val()
    var ben2_u_limit = $("#ben2_u_limit").val()
    var basic_income = $("#basic_income").val()
    var which_action = $("#which_action").val()
    $.ajax(
        { url: "http://localhost:8000/"+which_action+"/",
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
             console.log( "base[0][1]="+result["base"][0][1] );
             console.log( "changed[1][1]="+result["changed"][1][1] );
             // var r = JSON.parse( ""+result );
             if( which_action == "run" ){
                 stb.createMainOutputs( result );
             } else {
                 stb.createBCOutputs( result );

             }
         }
     });
}
