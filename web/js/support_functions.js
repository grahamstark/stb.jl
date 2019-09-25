window.stb = {} // Create global container


stb.runModel = function( page ){

    var it_allow = $("it_allow").val()
    var it_rate_1 = $("it_rate_1").val()
    var it_rate_2 = $("it_rate_2").val()
    var it_band = $("it_band").val()
    var benefit1 = $("benefit1").val()
    var benefit2 = $("benefit2").val()
    var ben2_l_limit = $("ben2_l_limit").val()
    var ben2_taper = $("ben2_taper").val()
    var ben2_u_limit = $("ben2_u_limit").val()
    $.ajax(
        { url: "localhost:8000/run/",
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
             ben2_u_limit: ben2_u_limit
         },
         success: function( result ){
             console.log( "stb; call UK");
             var r = JSON.parse( result );

         }
}
