import { Component, OnDestroy, OnInit } from '@angular/core';
import {
  ActivatedRoute,
  ActivatedRouteSnapshot,
  NavigationEnd,
  Router,
  RouterStateSnapshot,
} from '@angular/router';

import { Subscription, filter } from 'rxjs';

export enum AppLinkType {
  Route = 'route',
  ExternalLink = 'externalLink',
}

export interface AppLink {
  route: string;
  name: string;
  type: AppLinkType;
  isActive: boolean;
}

@Component({
  selector: 'app-nav-menu',
  templateUrl: './nav-menu.component.html',
  styleUrls: ['./nav-menu.component.scss'],
})
export class NavMenuComponent implements OnDestroy {
  linkTypes = AppLinkType;
  links: AppLink[] = [
    {
      route: '/',
      name: 'Home',
      type: AppLinkType.Route,
      isActive: false,
    },
    {
      route: '/counter',
      name: 'Counter',
      type: AppLinkType.Route,
      isActive: false,
    },
    {
      route: '/fetch-data',
      name: 'Fetch data',
      type: AppLinkType.Route,
      isActive: false,
    },
    {
      route: '/api',
      name: 'API',
      type: AppLinkType.ExternalLink,
      isActive: false,
    },
  ];

  routerSub: Subscription;

  constructor(private router: Router) {
    this.routerSub = this.router.events
      .pipe(filter((e) => e instanceof NavigationEnd))
      .subscribe({
        next: (value: NavigationEnd) => {
          this.links = this.links.map((e) => {
            return {
              ...e,
              isActive: value.url === e.route,
            };
          });
        },
      });
  }

  ngOnDestroy(): void {
    this.routerSub.unsubscribe();
  }
}
