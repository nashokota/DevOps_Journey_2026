import { Component, OnInit, OnDestroy } from "@angular/core";
import { Router } from "@angular/router";
import { Subscription } from "rxjs";
import { AuthService } from "src/app/services/auth.service";
import { User } from "src/app/models/User";

@Component({
  selector: "app-navbar",
  templateUrl: "./navbar.component.html",
  styleUrls: ["./navbar.component.css"]
})
export class NavbarComponent implements OnInit, OnDestroy {
  isLoading: boolean = true;
  user: User = null;
  private userSub: Subscription;

  constructor(public authService: AuthService, private router: Router) {}

  ngOnInit() {
    this.isLoading = false;
    this.userSub = this.authService.currentUserData.subscribe(user => {
      this.user = user;
    });
  }

  ngOnDestroy() {
    if (this.userSub) {
      this.userSub.unsubscribe();
    }
  }

  logout() {
    this.authService.logoutUser();
    this.authService.userDetails(null);
    this.router.navigate(["/"]);
  }
}
