net.Receive("uweed_msg", function()
	UWeed.Core.Msg(net.ReadString())
end)

UWeed.Core.Msg = function(msg)
	chat.AddText(UWeed.Config.PrefixColor, UWeed.Config.Prefix..": ", Color( 255, 255, 255 ), msg)
end

net.Receive("uweed_die", function()
	hook.Remove("RenderScreenspaceEffects", "uWeed_high")
end)