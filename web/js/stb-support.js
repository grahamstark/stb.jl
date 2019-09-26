window.stb = {}; // Create global container


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

         }
     });
}
