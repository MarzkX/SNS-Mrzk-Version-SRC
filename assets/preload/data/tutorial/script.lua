function onUpdate(elapsed)
   shakin = getPropertyFromClass('ClientPrefs','shaking')

   if shakin then
      cameraShake('camGame', 0.0008, 999999)
      cameraShake('camHUD', 0.0008, 999999)
   end
end