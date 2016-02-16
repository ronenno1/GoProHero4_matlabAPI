classdef goProHero4    
    methods(Static)
        function download(camera, type)
            fiels = urlread(['http://' camera.ip ':8080/videos/DCIM/100GOPRO/']);
            txt = regexprep(fiels,'<tr>(.*?)<td>(.*?)<a class="link" href="(.*?)">(.*?)</a>(.*?)</td>(.*?)</tr>','$3');
            txt = regexprep(txt,'<!DOCTYPE(.*?)"headings">','');
            txt = regexprep(txt,'</tbody>(.*?)</html>','');
            C = strsplit(txt, '\n');   
            images = [];
            if (strcmp(type, 'all') || strcmp(type, 'images')) 
                images = strtrim(C(find(~cellfun(@isempty, strfind(C,'JPG')))));
                if ~exist('./images/', 'dir')
                    mkdir('./images/');
                end;
            end;
            videos  = [];
            if (strcmp(type, 'all') || strcmp(type, 'videos')) 
                videos  = strtrim(C(find(~cellfun(@isempty, strfind(C,'MP4')))));
                if ~exist('./videos/', 'dir')
                    mkdir('./videos/');
                end;
            end;
            for i=1:size(images, 2)
                if exist(char(strcat('./images/', images(i))), 'file')
                    continue;
                end;
                
                image = strcat('http://', camera.ip, ':8080/videos/DCIM/100GOPRO/', images(i));
                rgbImage = imread(char(image));
                imwrite(rgbImage, strcat('./images/', char(images(i))));
                fprintf(strcat('Image copied to videos/', char(images(i)), '\n'));
            end
            for i=1:size(videos, 2)
                if exist(char(strcat('./videos/', videos(i))), 'file')
                    continue;
                end;
                video = char(strcat('http://', camera.ip, ':8080/videos/DCIM/100GOPRO/', videos(i)));
                urlwrite(video, strcat('./videos/', char(videos(i))));
                fprintf(strcat('Video copied to videos/', char(videos(i)), '\n'));

            end
        end

        function res = power_off(camera)
            res = goProHero4.bacpac_api(camera, 'PW', '0');
        end
        
        function res = take_pic(camera)
            res = goProHero4.camera_api(camera, 'SH', '2');
        end

        function res = start_record(camera)
            res = goProHero4.camera_api(camera, 'SH', '1');
        end

        function res = stop_record(camera)
            res = goProHero4.camera_api(camera, 'SH', '0');
        end

        function res = still_mode(camera)
            res = goProHero4.camera_api(camera, 'CM', '1');
        end

        function res = video_mode(camera)
            res = goProHero4.camera_api(camera, 'CM', '0');
        end

        
        function res = camera_api(camera, method, intParam)
            res = goProHero4.general_api(camera, 'camera', method, intParam);
        end

        function res = bacpac_api(camera, method, intParam)
            res = goProHero4.general_api(camera, 'bacpac', method, intParam)
        end
        
        function res = general_api(camera, api, method, intParam)
            res = '';
            if (~exist('intParam', 'var'))
                param = '';
            else
                param = ['?p=%0' intParam];
            end;    
            url = ['http://' camera.ip '/' api '/' method param];
            try
                urlread(url);
            catch exception
                res = exception.message;
            end;
            
        end
                
        function res = test(camera)
            if (~isfield(camera, 'ip') || strcmp(camera.ip, ''))
                res = 'Error: missing ip';
                return;
            end;
            try
                res = urlread(['http://' camera.ip ':8080'], 'Timeout', 1);
            catch exception
                res = exception.message;
                fprintf([res '\n']);
                return;
            end;
            res = '';

        end
    end
end

