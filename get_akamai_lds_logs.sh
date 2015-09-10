#!/bin/bash
package="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
date_format="$(date +%Y%m%d%H%M)"
function usage {
  echo "$package - Download Akamai LDS (Log Delivery Service) logs from ftp site"
  echo " "
  echo "$package [options]"
  echo " "
  echo "options:"
  echo "-h, --help                show brief help"
  echo "-u, --user                user id to connect to the hosted ftp"
  echo "-p, --passwd              password to connect to the hosted ftp"
  echo "-o, --output-dir=DIR      specify a directory to store the logs"
  echo "-f, --ftp-location=ftp/a  specify the ftp location to download the logs from"
  echo " "
  echo "Example: $package -u username -p 12£456 -o /var/logs/cdn -f ftp.abc.com/logs/akamai/today"
  exit 0
}

if [ $# -le 0 ]; then
  usage
fi

while test $# -gt 0; do
        case "$1" in
                -h|--help)
                        usage
                        ;;
                -o)
                        shift
                        if test $# -gt 0; then
                                export OUTPUT=$1
                        else
                                echo "no output dir specified"
                                exit 1
                        fi
                        shift
                        ;;
                --output-dir*)
                        export OUTPUT=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -u)
                        shift
                        if test $# -gt 0; then
                                export USERNAME=$1
                        else
                                echo "no output dir specified"
                                exit 1
                        fi
                        shift
                        ;;
                --user*)
                        export USERNAME=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -p)
                        shift
                        if test $# -gt 0; then
                                export PASSWORD=$1
                        else
                                echo "no output dir specified"
                                exit 1
                        fi
                        shift
                        ;;
                --passwd*)
                        export PASSWORD=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -f)
                        shift
                        if test $# -gt 0; then
                                export FTP_LOCATION=$1
                        else
                                echo "no output dir specified"
                                exit 1
                        fi
                        shift
                        ;;
                --ftp-location*)
                        export FTP_LOCATION=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                *)
                        break
                        ;;
        esac
done

wget -o $package.$date_format.log --user $USERNAME --password $PASSWORD $FTP_LOCATION $OUTPUT
exit 0;
