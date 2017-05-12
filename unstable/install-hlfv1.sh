(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� d{Y �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/�����}�s:�n�O��/�i� h�<^Q�D^���Q��h�&�/�c$��F~Nwc����V��N��4{��k��P����~�MC{9=��i��>dF\.�&�J�e�5�ߖ��2.�?�Rɿ�Y���T��%I���P�wo{�{�l�\�Z��r�K���l��+�r�SBV�/��5��N�;�����q0Ew�~z-�=�h. (J҅��|R�N�i����(>f���b�"��y8eS.a�4M�4�:$a��"�#��>M��ڎG�.�">��d�5�*�e����)�E����#���ſԐ2���WGpbCVk"/�A���&0�Z[�Nu��ty���,#�.��&���[�j��Z��P6m-hS���Zv�)�� n����W�،���@O+16)=�;�|<7�}��QQ��:�=��񔥇��VB�F��� �f�OX�z_^Ⱥ,R�B�#[�����ڷoЩ��*��5���M�K�����������w�]�������]����u�G���G	{��	��������Eݐ%�/���e�i�<p�!�e���,%>���-3�x�\���2@���d>��4M 3.T�,�x�LMk�y�DC)Ё�sJ[ä���nD&�!N;�q;E`�F�{��3{�Μ��+�9x��n�\�sv?>�;� =.TM(���Q��F�N�$"�J��Q�x$rQ&���}Yn	bG�s&
o��N< :�94��:q���[{(���\C0��)�p#ica���1���8?�.�B~A�'�xh���Tn�pJ�۟i��B�ӛ�B"N�U1"�6o��b�IdJ؍�i�v�k���2uN�em
h�	���\2T�p;ByWZj�����՝)�̵����y
 ���r��sM<�<���i��b���B���J�ύ%(��}��t9^eu�Ș��6|#;��a��l�E�$m.o4F�t�4W���%�(‗5����e�Ob`���1f��:���a�����w�\��$mIm45Q��u�!�%�H�X4�9����l���̆g���^�����6�@����� *�/$�G�Om�W�}��J������_���Dw��5��0o�w�~�K�[�{�<�CKn�c�0C��q"T�G�z	�B?bԷ*�!)Gv�A,�
�
�]����̽/S$y�@�� � �Pt%�ĳ	#�y"X�]2�ؽ-&�n�8�5�5�!���ĉ�����]=t���[���^�湘[��A+\�����{�Х��Soz�.��Ti�\OT�Z�@a����h�i��iʙ������E�r>� ����Mf��rB�=<�!�|-�t��������L^��B>J$��O'��� ׁ��C�(��3�f&$���	I4��������5�/����&�f,O`@�Ϲ)��3��%��j���Ur(q��C�����%���o`���?IRU�G)������������2P����_���=����1���?��t��e������?��W
���*����?�St��(Fxe���	p�d��CД�4�2��:F������8�^��w������(��"���+����8؏;���p����.��g	}��@���p�����ֲ�۶̈ɸ!'MS�L���-eXO6C����c�}��t�Y�̱�1G[K|���n�,�F	�6Kٞ�U��{�K��3����R�Q�������e���������j��]��3�*�/$�G��S���m�?�{���
���#��fk�/���0�`������F߻58v}&�C\����}@��r���L�1ɤޛJsk:�LІ����CE�ctW$a��:�;^o�a�����5Q�Ǡ)Q/�q�@�:ܠ�ɪc��,�=Ѻ�i[<2.g�cDґ����9��A�6h�p�4�Cr��mEl	`�8�v�vSt���MV&�����-�3�q�|�0�ٓI�28	LE5�xǰW�|h֣�ZLB6ޮ;-�mvZgiϔ��uG=��f�TS�%������d�R$/k7t !s���IV=h��x��_�����W�_>D���S�)��������?�x��w�w� ���Q���\"�Wh�E\����O�����+��������!���Z� U�_���=�&�p�Q��Ѐ�	�`h׷4�0�u=7pgX%a	�gQ�%Iʮ��~?�!�����P	��W.��S��+��JU,o86'��t�lc�=GZu�-���=yA
/����w�<��i%���䎢�$���x5�`O@��嘱U��v���u{b"�4x6���MF��sJɩ�nV������z~��)�/��Q����������Y�߱�CU������}}�R�\�8�T��W�
o_��.�?�X%�2���8����Q������a�����?�j��|��gi�.�#s�&]ƦX
u1
�\�e1���F�u� p�`���m�a}��(*e����9���>��t����0Qx1�v�z���`�]��c��F����_��Yh����8��u��RTO�È�<j̄�]��kF�A��!�Sn;�"l�z&⚠:����l���y7>r��t��AW�_)��?�$���������'��՗FU(e���%ȧ��DaV�_x-��}�������;b%�A�*�5��`����,��x����%���?c�~�0�߃��\�[7�ndD�o�ݰ偆�A�74��k�];�L(�|#�S:�X̋�t�v:#������mc�y[�ȵ�f��#<���39��&���k�͛#���L�-��%��f�f�����'�n��(F�|d�ψA��:�����9Z��5��nM]9�5��	+�����Bm���_�SI�;�!qk!̻��!@]�Hr��pY�n���a���&8L9��Ӽ��+.��Sh+��mg#���s�O	+g�O�� r��A 5Ý�i'�I�D��?�}z��Vu}�Ț�Ґ^<�G��������ǉ��/���O���7�s��j+7�D���v��@�*�{)x�������q`�~��[����NS!�����������䙡��7P���A���>9��my�@M�w]��-�_�'� �	!c;9�ݔ����E%qG4�f#�e�\k�-[�)Ѷw�o�T�]K�t*�1I�4�.�S��]K$�_����4^�=M��|gs���l��f��9r5��Z�lޥ�ݴo���<k$���Ž������Z�-Xr�\���������i4l����BEا���<{�)>R����r���*����?�,��:�S>c�W����!��������?����_��W��o����s���aX�����r�_n�]����U�g)��������\��-�(���O��o��r�'<¦iCI�b�d	��}�H�'p&@�vq�Q�!֧���u1�a0���[���b��(��T�?����?@i��-'�}˜�1lv�C���s�`�����GڢEM^<�c�9��v�u%���Qt/YS\��A@����X�%5�Zߺ�#j��������pF�ehr��Lo�W�(�M{h^��y/�؝�i���$���}���g�|��8B>��B�X��_�`�Y���������O�S�ϾB��k#�K�6����Z��?]�^X,��vҩ{��_wuCW�5r�\ًdb�>�/��4^F�r}�I�vU� ���n�]E��k��]�������8]g���/!����u*+&nd/���lR�rk=�G�(�u��(�>�VӅ_{��O�}��8�h��/��dΫ]9��������ڕw�m��D��1��/�������v��k{��ӛ��µo�nnm�ۙ��]�+���Es���.�7Quй��}CT� �b���>�y���ڗ��h4�·�l_k*ɝ���@�w�:��4̮o�ʵ�(��˝���{��{�@���ւ�?�A�%wۋ70:��bl��X|W{���e�-o�� ��O[/�������
��8�?���z����n��A��~+�~�����=�����E�����w�j���2����'k8�{=��ԅ��z�q������Hj�Z�a�MX�@��)��x���&�f����pF�=��é��pls�b໺x�7���]A�G"?0DCV�����-��mUqd|[��q��kF�ue���YNw_a�����)�n��ْ��.���w�1�[e����Nϥ�SW,��A�Ew��q��@���I�q�;Y��Ǳ�8���w�T@BHEV,B����Q�?@���.j%�|�+��ݢ�����x�I2��NoK���~χ���9�_?�+g&
�����-^�Ŧ�9�`b�˕[r(!a�q(�R���e�||5<��@Wd��s�D�V:KFIhm��1�ɓ���/�e4�"�v��i=0-�@,���M=
D�yM:&��,� �1aZ�;]]Yt�UEQ\���ZM��p	24A���a�Ԏ�ɀ�a� ���]f\�a�Xxd��ݮf@݄�h<6UIp�>:��G��;��x��t.?�!h�R:˰�r�;-A�U�|O�B�[�9�&\�f��y��*���4b	�E��?p��m�}|ш_9|�r��xi�Xu�DM�Ԍ[�C�o����h��GS썍��0�u��� mN�����L�:pz68,�)� ��W��?X�i=���:��bg�oj
?�t�ש���G	�y���Q����.�礖����A7�f3i'����	�ӟ��\.7�ˎ(�=��U�E�p?� ede�sKW�5�o��C�<*QAohf�`���\���ՇC�r�.���ǖ/C�*�J�\̔�z��g�>&ׅ�P䦵@٪Fi�:*�n�a� ��,	5:}�%.-��^���:r�h_/����lI�7v�|�s���#�Zj4r�$�Bُۣ%)h��)3�%��t���]fLЊ�-�Y�xڛ�Ń�ht��ܽ�!,�bg�P��d�W�ת�N�.�l��ַ��s�.܁[����1�t�i��M������#�|>y�&�_�:���������������W?�_$�Ӡ�ua���O�������V�O�cuo����CL!>�c�~<Xq/���E<��}��z�G"P�|B|.��>q�����\}{�������=�z����O������ֳ��A�x����|�A��wO�����o�0.�����7��7���_C�p�ܵ��_�x�1,���g�����]i��H7�y����r9��B������� eN��I��di��"�`d��o�1D��=Po�[*�A�Qo"U�ʽ�n	�S���
�RL��ώ9����%�9���B�d�a�N�A3�����f����l3�KVLEr�6g��+Q�*�^� �Ch����l��,�gÓ��yr&�J��[�,Er��h��Z����SJ��k4��#%[��������w�����<N��2�*��2<_��!���3�����CFP�r���%�	�0a&�&LX��'"�~�DX�X���m�	����]��[jFHy �=57BֽzD@)�oĳ-�a���'����~�
�W�fRE�F��]��"�K�`�5�X�)8-�t��S
0�:��ܸ�e�l5�r4R�n,���B�������X�����.J��ah�LF0T��^�(f��(W�1:�	��<�0�d#J-�iY��kE߸/Գ�T��%J-)�Gz��@��b�n���+K���e��ʲ����#Z���d�@��GAo�%�Y�8��b}@�� 't��b�G��y�3�E�Q����m&\J2���u1�P�Fu��gN�,$��E��016Z��òl�+����YR�#��k�%���H�<ĳ�1M}1�vJ�*�zz����E�mV&1KYF�z��?�k�0���u&k�B���z�H��P�(Rzm�%�JY�+�ex��47P�8����{5��Ӵ7�)��#O��i�76څ��G�ZV;dil!=Jj�wP�Ƶj�O����JO5�=��D�tCI�b��CU��1.����-)��ٵ��EvQ�8@��=^oY��K(;��A9�hQ<%����-`p� '�� @��F[��R�JM�X���2_�a��ח.�Z�q��v|6�gs|��|��K��3�8���7��n �B�m݉� [�%����;W�7ϿJۙ|`z��@\P��sy��+�y�*+�SU����0�d3Į�������.���6l�G�J��AUi#��~p)��%err�a� 5�)dE��7���5Wս<#v���i"��\UQm7��jM�1�� ����3�|���3.�6�v�\E�l�	���l�ྰI,�J�f�y+r/��~s���f�LO��̞�r�o_�IM�}1������3�bE���";�����č\ �eEҷ�Ύ��O������˟���o#��}X��R�l�R�܉C�d����� ۡ)�����R�
;���o/���t���Hɬ��梃��dа��{8��`�+G�9��Z,Oc�Ysȃ��{��A��T��c
퍙]�5,�~���4"�+�>΅���j�T'��#X#�A��R*,��%��RċйM7ٴ!T��8\cI��ʑ�=�8֚dL�=!ca)k�ӧ13�%�!{���JD��bz���ן���D�����5
4�J�8�d�b���P�ԒAm��h���|ԇuP���7�F`\l펇#c��B�$�pG��hӋ�n�D }�F�j���R�(�	=�8܎q8���	~���Kzyt*�:�\^6���c2�c�3m��=�G�����s�E.�}ޙ��=���n����1���'�������r"io�Hڦ�Hn.8·*�Z��H]Hs�&��GĒ��|�����b�GkQ�I�`����D�Y�"�V�IPd�Ys�5�+�w��Nok)B�hI9B��Q8�ΐ������0.z��p4����!$��j}mE��둪�GG�a �f+cR4^������Cc!T��_DA��)��+m��hg_�{R�~�Em��_�Y:(W�7&���W252-��Ru�y.�1�|<�rpak{ji����rjO!т�<-�f����i��hVh�إ�7���p����8N��x#~9e�S;e96}m�� ̶s<h��"|�����H����=݊n����ķ�M�V�E��k��{����u�=-�T$ނ�Fd\��I�?p���z呥8��$�<."�;l7�&��]���O^�����c��?�◞��w|���>��� �����VW��|7'-���Ϲ�����������-	�w\_��}�)����.�GF��d�'?������Of�F��E�ߓ�KI��$���4�~�W�rW4&Ӊ5d�����|߻��h�?������Ǒ_|�_?��G~À��W��9j����ˋ��_:�N���P;��Cp���W���W\' ��j�C�t������l�j�����z���Mh�Ap�2C�\���m�����@=�x�9Cg}�������#/�Q^@����9<�S��)��8���k�38G����Af�����٬�93N�ՙ3�Lp�8sf�p��6̙9�|�3L��3sn�w���Mi��.y�ɜ��/�;h�1��$'9�INzݦ�S���  