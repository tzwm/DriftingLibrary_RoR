$().ready(function(){
	$("#form-signup").validate({
		rules: {
			user_name: {
				required: true,
				minlength: 2
			},
			user_password: {
				required: true,
				minlength: 5
			},
			user_password_confirmation: {
				required: true,
				minlength: 5,
				equalTo: "#user_password"
			},
			user_email: {
				required: true,
				email: true,
				remote:{
					type:"GET",
					url:"validate.do",
					data:{email:function(){return $("#user_email").val();}}
				}
			},
			rand:{
				required:true,
				remote:{
					type:"GET",
					url:"randValidate.do",
					data:{code:function(){return $("#rand").val();}}
				}
			}
		},
		messages: {
			user_name: {
				required: "Please enter a username",
				minlength: "Your username must consist of at least 2 characters"
			},
			user_password: {
				required: "Please provide a password",
				minlength: "Your password must be at least 5 characters long"
			},
			user_password_confirmation: {
				required: "Please provide a password",
				minlength: "Your password must be at least 5 characters long",
				equalTo: "Please enter the same password as above"
			},
			user_email:{
				remote:jQuery.format("The email has been registered!")
			},
			rand:{
				remote:jQuery.format("Vertification Code Error")
			}
		}
	});
});