camera.ip = '10.5.5.9';
if ~strcmp(goProHero4.test(camera), '')
    return;
end;

res = goProHero4.still_mode(camera);
for i=1:3
    res = goProHero4.take_pic(camera);
    pause(2);
end;
res = goProHero4.video_mode(camera);
pause(1);
goProHero4.start_record(camera);
pause(5);
goProHero4.stop_record(camera);
goProHero4.download(camera, 'all');
