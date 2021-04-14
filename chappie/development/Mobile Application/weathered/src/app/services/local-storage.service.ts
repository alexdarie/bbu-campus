import { Injectable } from '@angular/core';
import { Plugins } from '@capacitor/core';

const { Storage } = Plugins;

@Injectable({
  providedIn: 'root'
})
export class LocalStorageService {

  constructor() { }

  set(items: any[]) {
    console.log('local-storage.service: set: ', items);
    Storage.set({
      key: 'items',
      value: JSON.stringify(items)
    });
  }

  async get() {
    const item = await Storage.get({ key: 'items' });
    console.log('local-storage.service: async get: ', item.value);
    return JSON.parse(item.value);
  }

  append(akey: string, items: any[]) {
    console.log('local-storage.service: append: ', items, 'at key: ', akey);
    Storage.set({
      key: akey,
      value: JSON.stringify(items)
    });
  }

  async at(akey: string) {
    const item = await Storage.get({ key: akey });
    console.log('local-storage.service: async at: ', item.value);
    if (item.value != null && item.value !== '') {
      console.log(';' + item.value + ';');
      return JSON.parse(item.value);
    } else {
      return [];
    }
  }
}
