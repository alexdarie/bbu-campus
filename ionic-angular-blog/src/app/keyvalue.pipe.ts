import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'keyvalue'
})
export class KeyvaluePipe implements PipeTransform {

  transform(map): any[] {
    let ret = [];

    map.forEach((val, key) => {
        ret.push({
            key: key,
            value: val
        });
    });

    return ret;
  }

}
